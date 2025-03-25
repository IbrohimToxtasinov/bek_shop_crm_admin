enum FormStatus {
  pure,

  /// Category
  // get
  categoryLoading,
  categorySuccess,
  categoryFail,
  // add
  addCategoryLoading,
  addCategorySuccess,
  addCategoryFail,
  // update
  updateCategoryLoading,
  updateCategorySuccess,
  updateCategoryFail,
  // delete
  deleteCategoryLoading,
  deleteCategorySuccess,
  deleteCategoryFail,
  // upload category image
  uploadImageCategoryLoading,
  uploadImageCategorySuccess,
  uploadImageCategoryFail,

  /// Product
  // get
  productLoading,
  productSuccess,
  productFail,
  // add
  addProductLoading,
  addProductSuccess,
  addProductFail,
  // update
  updateProductLoading,
  updateProductSuccess,
  updateProductFail,
  // delete
  deleteProductLoading,
  deleteProductSuccess,
  deleteProductFail,
  // upload product image
  uploadImageProductLoading,
  uploadImageProductSuccess,
  uploadImageProductFail,
}
