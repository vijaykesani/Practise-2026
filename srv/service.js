export default cds.service.impl( async function() {
    // There are three types of generic handlers which are available. .before(), .on(), .after()
    // .before() : Generic handler to perform pre-checks / validation before upating the data into the database
    // .on() : Generic handler to perform DB Operation
 
    // Step-1 : Get the object from ODATA entities
    let { EmployeeSrv, POSrv } = this.entities;
 
    // Step-2 : Define generic handler to perform pre-checks / validations
    this.before('UPDATE', EmployeeSrv, (request, response) =>{
        console.log("Salary : ", request.data.salaryAmount);
        if(parseFloat(request.data.salaryAmount) >= 75000){
            request.error(403, "Please get the approval from your line manager!");
        }
    })
 
    // Implementation of custom function
    this.on('getEmployeeInfo', async(request, response) =>{
        try {
            // Step-1 : Declare a transaction request
            const transaction = cds.tx(request);
 
            // Step-2 : Read the data from database using transaction request
            const reply = await transaction.read(EmployeeSrv).orderBy({
                salaryAmount : 'desc'
            }).limit(10);
 
            // Step-3 : Return it back
            return reply;
        } catch (error) {
            return "Error : " + error.toString();
        }
    })
 
    // Implementation of custom action
    this.on('createEmployee', async(request, response) =>{
        const dataset = request.data.input;
 
        let returndata = await cds.tx(request).run([
            INSERT.into(EmployeeSrv).entries(dataset)
        ]).then((resolve, reject)=>{
            if(typeof(resolve) !== undefined){
                console.log("Successfully inserted..!")
            } else {
                request.error(500, "Error in creation of Employee");
            }
        }).catch(error =>{
            request.error(500, "There is an error : " + error.toString());
        })
 
        let employeedata = await cds.tx(request).read(EmployeeSrv).where({
            ID : request.data.input.ID
        });
        return employeedata;
    })
 
    // Implementation of Instance Bounded Function
    this.on('largestOrder', async(request, response) =>{
        try {
            const transaction = cds.tx(request);
            const reply = await transaction.read(POSrv).orderBy({
                GROSS_AMOUNT : 'desc'
            }).limit(5);
 
            return reply;
        } catch (error) {
            return "Error : " + error.toString();
        }
    })
 
    // Implementation of Instance Bounded Action
    this.on('discountPrice', async(request, response) =>{
        try {
            const ID = request.params[0];
 
            const transaction = cds.tx(request);
 
            await transaction.update(POSrv).with({
                GROSS_AMOUNT : {
                    '-=' : 1000
                },
                NET_AMOUNT : {
                    '-=' : 800
                },
                TAX_AMOUNT : {
                    '-=' : 200
                }
            }).where(ID)
        } catch (error) {
            return "Error : " + error.toString();
        }
    })
})