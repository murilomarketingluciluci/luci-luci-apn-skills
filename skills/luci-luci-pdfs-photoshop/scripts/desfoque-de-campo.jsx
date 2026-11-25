function aplicarDesfoqueDeCampo(pinos) {
    var doc = app.activeDocument;
    if (doc.activeLayer.kind !== LayerKind.SMARTOBJECT) {
        throw Error("Selecione o objeto inteligente da tipografia.");
    }
    var s = stringIDToTypeID, c = charIDToTypeID;
    var filtro = new ActionDescriptor();
    var tela = new ActionDescriptor();
    tela.putInteger(c("Top "), 0);
    tela.putInteger(c("Left"), 0);
    tela.putInteger(c("Rght"), Math.round(doc.width.as("px")));
    tela.putInteger(c("Btom"), Math.round(doc.height.as("px")));
    filtro.putObject(s("referenceRect"), c("Rctn"), tela);
    filtro.putBoolean(s("blurbType"), true);
    filtro.putInteger(c("VrsM"), 1);
    filtro.putInteger(c("VrsN"), 0);
    filtro.putInteger(s("blurbOpenPanel"), 0);
    filtro.putBoolean(s("blurbGeneralBlurEffectApplied"), true);
    filtro.putBoolean(s("blurbSaveMaskChannel"), false);
    filtro.putBoolean(s("blurbHighQuality"), true);
    var lista = new ActionList();
    for (var i = 0; i < pinos.length; i++) {
        var p = new ActionDescriptor();
        p.putInteger(s("blurbWidgetType"), 0);
        p.putDouble(s("blurbWidgetLocationX"), pinos[i][0]);
        p.putDouble(s("blurbWidgetLocationY"), pinos[i][1]);
        p.putDouble(s("blurbGeneralBlurAmount"), pinos[i][2]);
        p.putBoolean(s("blurbWidgetEffectEnabled"), true);
        p.putBoolean(s("blurbWidgetSelected"), i === pinos.length - 1);
        lista.putObject(s("blurbWidget"), p);
    }
    filtro.putList(s("blurbWidgetList"), lista);
    executeAction(s("blurbTransform"), filtro, DialogModes.NO);
}
