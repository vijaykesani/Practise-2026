namespace porderapp.view;

using { porderapp.db.master as master, porderapp.db.transaction as transaction } from './schema';

context CDSViews {
   define view ![POWorklist] as select from transaction.PurchaseOrders {
    key PO_ID as ![PurchaseOrderID],
    key Items.PO_ITEMS_POS as ![ItemPosition],
    PARTNER.BP_ID as ![BusinessPartnerID],
    GROSS_AMOUNT as ![GrossAmount],
    NET_AMOUNT as ![NetAmount],
    TAX_AMOUNT as ![TaxAmount],
    CURRENCY as ![Currency],
    OVERALL_STATUS as ![OverallStatus],
    Items.PRODUCT.PRODUCT_ID as ![ProductID],
    Items.PRODUCT.DESCRIPTION as ![ProductDescription],
    PARTNER.ADD.CITY as ![City],
    PARTNER.ADD.COUNTRY as ![Country]
};

define view ![ItemView] as select from transaction.PurchaseItems {
    PARENT.PARTNER.NODE_KEY as ![CustomerKey],
    PRODUCT.NODE_KEY as ![ProductKey],
    CURRENCY as ![Currency],
    GROSS_AMOUNT as ![GrossAmount],
    NET_AMOUNT as ![NetAmount],
    TAX_AMOUNT as ![TaxAmount],
    PARENT.OVERALL_STATUS as ![Status],
};

define view ![Productview] as select from master.Products
mixin {
    PO_ORDER: Association[*] to ItemView on PO_ORDER.ProductKey = $projection.ProductKey
}
into {
    NODE_KEY as ![ProductKey],
    DESCRIPTION as ![Description],
    CATEGORY as ![Category],
    PRICE as ![Price],
    SUPPLIER.BP_ID as ![SupplierID],
    SUPPLIER.ADD.CITY as ![City],
    SUPPLIER.ADD.COUNTRY as ![Country],
    PO_ORDER as ![ToItems]
}
}
