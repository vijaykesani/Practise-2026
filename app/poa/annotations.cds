using CatalogService as service from '../../srv/service';
 
annotate service.POSrv with {
    PO_ID        @Common: {ValueList: {
        $Type          : 'Common.ValueListType',
        Label          : 'Purchase Order ID',
        CollectionPath : 'POSrv',
        SearchSupported: true,
        Parameters     : [{
            $Type            : 'Common.ValueListParameterOut',
            LocalDataProperty: 'PO_ID',
            ValueListProperty: 'PO_ID'
        }]
    }};
 
    COMPANY_NAME @Common: {ValueList: {
        $Type          : 'Common.ValueListType',
        Label          : 'Company Name',
        CollectionPath : 'BPSrv',
        SearchSupported: true,
        Parameters     : [
            {
                $Type            : 'Common.ValueListParameterInOut',
                LocalDataProperty: 'BP_ID',
                ValueListProperty: 'BP_ID'
            },
            {
                $Type            : 'Common.ValueListParameterOut',
                LocalDataProperty: 'COMPANY_NAME',
                ValueListProperty: 'COMPANY_NAME'
            }
        ]
    }, }
 
 
};
 
annotate service.POSrv with @(
    UI.SelectionFields       : [
        PO_ID,
        GROSS_AMOUNT,
        COMPANY_NAME,
        PARTNER.ADD.COUNTRY
    ],
    UI.LineItem              : [
        {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER.COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER.BP_ID
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type            : 'UI.DataFieldForAction',
            Action           : 'CatalogService.discountPrice',
            Label            : 'Discount',
            Inline           : true,
            ![@UI.Importance]: #High,
            ![@UI.Hidden]    : {$edmJson: {$Lt: [
                {$Path: 'GROSS_AMOUNT'},
                10000
            ]}}
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        },
        {
            $Type      : 'UI.DataField',
            Value      : LST,
            Criticality: LSC
        },
        {
            $Type      : 'UI.DataField',
            Value      : OST,
            Criticality: OSC
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER.ADD.COUNTRY
        }
    ],
    UI.HeaderInfo            : {
        TypeName      : 'Purchase Order',
        TypeNamePlural: 'Purchase Orders',
        Title         : {
            Label: 'Purchase Order ID',
            Value: PO_ID
        },
        Description   : {
            Label: 'Company Name',
            Value: PARTNER.COMPANY_NAME
        },
        ImageUrl      : 'https://m.economictimes.com/thumb/msid-87828966,width-1200,height-900,resizemode-4,imgsize-11478/tata-technologies.jpg'
    },
    UI.Facets                : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Purchase Order Details',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Business Parnter Details',
                    Target: '@UI.FieldGroup#BPDetails'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Amount Details',
                    Target: '@UI.FieldGroup#AmountInfo'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status Details',
                    Target: '@UI.FieldGroup#StatusDet'
                }
            ]
        },
        {
            $Type : 'UI.ReferenceFacet',
            Label : 'Purchase Item',
            Target: 'Items/@UI.LineItem'
        }
    ],
    UI.FieldGroup #BPDetails : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PARTNER.BP_ID
            },
            {
                $Type: 'UI.DataField',
                Value: PARTNER.BP_ROLE
            },
            {
                $Type: 'UI.DataField',
                Value: PARTNER.COMPANY_NAME
            },
            {
                $Type: 'UI.DataField',
                Value: PARTNER.MOBILE
            },
            {
                $Type: 'UI.DataField',
                Value: PARTNER.FAX
            },
            {
                $Type: 'UI.DataField',
                Value: PARTNER.EMAIL
            }
        ]
    },
    UI.FieldGroup #AmountInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PO_ID
            },
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT
            }
        ]
    },
    UI.FieldGroup #StatusDet : {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type      : 'UI.DataField',
                Value      : LST,
                Criticality: LSC
            },
            {
                $Type      : 'UI.DataField',
                Value      : OST,
                Criticality: OSC
            }
        ]
    }
);
 
annotate service.POItemsSrv @(
    UI.LineItem  : [
        {
            $Type: 'UI.DataField',
            Value: PO_ITEMS_POS
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT_NODE_KEY
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.PRODUCT_ID
        },
        {
            $Type: 'UI.DataField',
            Value: PRODUCT.DESCRIPTION
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: NET_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: TAX_AMOUNT
        },
        {
            $Type: 'UI.DataField',
            Value: CURRENCY_code
        }
    ],
    UI.HeaderInfo: {
        TypeName      : 'Purchase Item',
        TypeNamePlural: 'Purchase Items',
        Title : {
            $Type : 'UI.DataField',
            Value : PO_ITEMS_POS
        },
        Description : {
            $Type : 'UI.DataField',
            Value : PRODUCT.DESCRIPTION
        }
    },
    UI.Facets                : [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Purchase Item Details',
            Facets: [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Amount Details',
                    Target: '@UI.FieldGroup#POItemInfo'
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Product Details',
                    Target: '@UI.FieldGroup#ProductInfo'
                }
            ]
        }
    ],
    UI.FieldGroup #POItemInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PO_ITEMS_POS
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT_NODE_KEY
            },
            {
                $Type: 'UI.DataField',
                Value: GROSS_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: NET_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: TAX_AMOUNT
            },
            {
                $Type: 'UI.DataField',
                Value: CURRENCY_code
            }
        ]
    },
    UI.FieldGroup #ProductInfo: {
        $Type: 'UI.FieldGroupType',
        Data : [
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.PRODUCT_ID
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.DESCRIPTION
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.TYPE_CODE
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.DIM_UNIT
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.WEIGHT_MEASURE
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.WEIGHT_UNIT
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.PRICE
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.WIDTH
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.HEIGHT
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.DEPTH
            },
            {
                $Type: 'UI.DataField',
                Value: PRODUCT.TAX_TARIF_CODE
            }
        ]
    }
)
 
 
 
 
 
  