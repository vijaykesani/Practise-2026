namespace porderapp.db;
 
using { porderapp.reuse as reuse } from './reuse';
using {
    cuid,
    Currency
} from '@sap/cds/common';
 
 
context master {
    entity BusinessPartners {
        key NODE_KEY : reuse.identity @(title: '{i18n>NODE_KEY}');
        COMPANY_NAME : reuse.Name @(title: '{i18n>COMPANY_NAME}');
        BP_ROLE : reuse.Role @(title: '{i18n>BP_ROLE}');
        EMAIL : reuse.Email @(title: '{i18n>EMAIL}');
        MOBILE : reuse.PhoneNumber @(title: '{i18n>MOBILE}');
        FAX : String(32) @(title: '{i18n>FAX}');
        WEB : reuse.Name @(title: '{i18n>WEB}');
        BP_ID : reuse.identity @(title: '{i18n>BP_ID}');
        ADD : Association to one Addresses @(title: '{i18n>ADDRESS_GUID}');
    }
 
    entity Addresses : reuse.Address {
        key NODE_KEY : reuse.identity @(title: '{i18n>NODE_KEY}');
        ADDRESS_TYPE : String(32) @(title: '{i18n>ADDRESS_TYPE}');
        VAL_START : Date @(title: '{i18n>VAL_START}');
        VAL_END : Date @(title: '{i18n>VAL_END}');
        LATITUDE : Decimal @(title: '{i18n>LATITUDE}');
        LONGITUDE : Decimal @(title: '{i18n>LONGITUDE}');
        // Unmanaged Association
        BUSPART : Association to one BusinessPartners on BUSPART.ADD = $self @(title: '{i18n>SUPPLIER_GUID}');
    }
 
    entity Products {
        key NODE_KEY : reuse.identity @(title: '{i18n>NODE_KEY}');
        PRODUCT_ID : String(32) @(title: '{i18n>PRODUCT_ID}');
        TYPE_CODE : String(2) @(title: '{i18n>TYPE_CODE}');
        CATEGORY : String(32) @(title: '{i18n>CATEGORY}');
        DESCRIPTION : reuse.Name @(title: '{i18n>DESCRIPTION}');
        TAX_TARIF_CODE : Integer @(title: '{i18n>TAX_TARIF_CODE}');
        MEASURE_UNIT : String(2) @(title: '{i18n>MEASURE_UNIT}');
        WEIGHT_MEASURE : Decimal(5,2) @(title: '{i18n>WEIGHT_MEASURE}');
        WEIGHT_UNIT : String(2) @(title: '{i18n>WEIGHT_UNIT}');
        PRICE : Decimal(15,2) @(title: '{i18n>PRICE}');
        CURRENCY_CODE : String(4) @(title: '{i18n>CURRENCY_CODE}');
        WIDTH : Decimal(5,2) @(title: '{i18n>WIDTH}');
        DEPTH: Decimal(5,2) @(title: '{i18n>DEPTH}');
        HEIGHT : Decimal(5,2) @(title: '{i18n>HEIGHT}');
        DIM_UNIT : String(2) @(title: '{i18n>DIM_UNIT}');
        // Managed Association
        SUPPLIER : Association to one BusinessPartners @(title: '{i18n>SUPPLIER_GUID}}');
    }
 
    entity Employees : cuid, reuse.BankDet {
        nameFirst : reuse.Name;
        nameLast : reuse.Name;
        nameInitials : reuse.Name;
        nameMiddle : reuse.Name;
        gender : reuse.Gender;
        language : String(2);
        loginName : String(16);
        phoneNumber : reuse.PhoneNumber;
        email : reuse.Email;
        Currency : Currency;
        salaryAmount : reuse.AmountT;
    }
}
 
context transaction {
    entity PurchaseOrders : reuse.Amount{
        key NODE_KEY : reuse.identity @(title: '{i18n>NODE_KEY}');
        PO_ID : reuse.identity @(title: '{i18n>PO_ID}');
        // Managed Association
        PARTNER : Association to one master.BusinessPartners @(title: '{i18n>PARTNER_GUID}');
        LIFECYCLE_STATUS : String(1) @(title: '{i18n>LIFECYCLE_STATUS}');
        OVERALL_STATUS : String(1) @(title: '{i18n>OVERALL_STATUS}');
        // Unmanaged Association - one to many
        Items : Association to many PurchaseItems on Items.PARENT = $self ;
    }
 
    entity PurchaseItems : reuse.Amount {
        key NODE_KEY : reuse.identity @(title: '{i18n>NODE_KEY}');
        PO_ITEMS_POS : Int16 @(title: '{i18n>PO_ITEMS_POS}');
        PARENT : Association to PurchaseOrders @(title: '{i18n>PARENT_KEY}');
        // Managed Association - one to one
        PRODUCT : Association to master.Products @(title: '{i18n>PRODUCT_GUID}');
    }
}