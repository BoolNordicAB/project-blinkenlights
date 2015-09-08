var designMode = function () {
  /// tells you whether the page is in design mode or not.
  return document.forms[MSOWebPartPageFormName].MSOLayout_InDesignMode.value == '1';
};
