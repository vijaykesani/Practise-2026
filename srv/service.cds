using { porderapp.db as porder } from '../db/schema';
using { porderapp.reuse as reuse } from '../db/reuse';
 
 
type employeInput {
      Currency_code: String(3);
      ID: UUID;
      accountNumber: String(16);
      bankId: String(16);
      bankName: reuse.Name;
      email: reuse.Email;
      gender: reuse.Gender;
      language: String(2);
      loginName: String(16);
      nameFirst: reuse.Name;
      nameInitials: reuse.Name;
      nameLast: reuse.Name;
      nameMiddle: reuse.Name;
      phoneNumber: reuse.PhoneNumber;
      salaryAmount: reuse.AmountT;
}
 
service CatalogService {
 
    // Service definition for Employees
    entity EmployeeSrv as projection on porder.master.Employees;
   
    // Service definition for Business Partners
    entity BPSrv as projection on porder.master.BusinessPartners;
 
    // Service definition for Addresses
    entity AddressSrv as projection on porder.master.Addresses;
 
    // Service definition for Products
    entity ProductsSrv as projection on porder.master.Products;
 
    // Service definition for Purchase Orders
    entity POSrv as projection on porder.transaction.PurchaseOrders{
        *,
        PARTNER.COMPANY_NAME as COMPANY_NAME,
        PARTNER.BP_ID as BP_ID,
        case LIFECYCLE_STATUS
            when 'N' then 'Not Started'
            when 'P' then 'Pending'
            when 'D' then 'Delivered'
            when 'R' then 'Returned'
            end as LST : String(15) @title : '{i18n>LIFECYCLE_STATUS}',
        case OVERALL_STATUS
            when 'N' then 'New'
            when 'P' then 'Paid'
            when 'X' then 'Not Paid'
            when 'C' then 'Completed'
            else 'Cancelled'
            end as OST : String(15) @title : '{i18n>OVERALL_STATUS}',
        case LIFECYCLE_STATUS
            when 'N' then 1
            when 'P' then 2
            when 'D' then 3
            when 'R' then 2
            end as LSC : Int16,
        case OVERALL_STATUS
            when 'N' then 1
            when 'P' then 3
            when 'X' then 2
            when 'C' then 3
            else 2
            end as OSC : Int16
    } actions {
// -------------- RELATED TO PURCHASE ORDER ENTITY -----------------------------------
        // Declaration : Instance Bounded Function
        function largestOrder() returns array of POSrv;
 
        // Declaration : Instance Bounded Action
        @cds.odata.bindingparameter.name: 'DP'
        @Common.SideEffects : {
            TargetProperties : ['DP/GROSS_AMOUNT', 'DP/NET_AMOUNT', 'DP/TAX_AMOUNT']
        }
        action discountPrice();
// -------------- RELATED TO PURCHASE ORDER ENTITY -----------------------------------
    };
 
    // Service definition for Products
    entity POItemsSrv as projection on porder.transaction.PurchaseItems;
 
// -------------- NOT RELATED TO ANY ENTITIES -----------------------------------
    // Declaration : Custom Function
    function getEmployeeInfo() returns array of String;
 
    // Declaration : Custom Action
    action createEmployee(input : employeInput) returns array of  EmployeeSrv;
// -------------- NOT RELATED TO ANY ENTITIES -----------------------------------
}