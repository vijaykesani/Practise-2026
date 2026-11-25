sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"poa/poa/test/integration/pages/POSrvList.gen",
	"poa/poa/test/integration/pages/POSrvObjectPage.gen",
	"poa/poa/test/integration/pages/POItemsSrvObjectPage.gen"
], function (JourneyRunner, POSrvListGenerated, POSrvObjectPageGenerated, POItemsSrvObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('poa/poa') + '/test/flp.html#app-preview',
        pages: {
			onThePOSrvListGenerated: POSrvListGenerated,
			onThePOSrvObjectPageGenerated: POSrvObjectPageGenerated,
			onThePOItemsSrvObjectPageGenerated: POItemsSrvObjectPageGenerated
        },
        async: true
    });

    return runner;
});

