package com.pahanaedu.daotest;

import com.pahanaedu.dao.ProductDAO;
import com.pahanaedu.model.Product;
import org.junit.jupiter.api.*;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class ProductDAOTest {

    private ProductDAO productDAO;
    private Product testProduct;

    @BeforeAll
    void init() {
        productDAO = new ProductDAO();
    }

    @BeforeEach
    void setUp() throws Exception {
        // Create a sample product for testing
        testProduct = new Product();
        testProduct.setTitle("Test Book");
        testProduct.setDescription("A test book description");
        testProduct.setAuthor("John Doe");
        testProduct.setPublisher("Test Publisher");
        testProduct.setPublicationDate(LocalDate.now());
        testProduct.setCategory("Education");
        testProduct.setPrice(50.0);
        testProduct.setStockQuantity(10);
        testProduct.setImagePath("images/test_book.jpg");
        testProduct.setActive(true);
        testProduct.setDiscountPercentage(10.0);
        testProduct.setFeatured(true);

        productDAO.saveProduct(testProduct); // should succeed
    }

    @AfterEach
    void tearDown() {
        if (testProduct.getProductId() > 0) {
            try {
                productDAO.deleteProduct(testProduct.getProductId());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

//    @Test
//    void testSaveProductSuccess() {
//        assertNotNull(testProduct.getProductId(), "Product ID should be generated after saving");
//    }

//    @Test
//    void testGetProductByIdSuccess() throws Exception {
//        Product retrieved = productDAO.getProductById(testProduct.getProductId());
//        assertNotNull(retrieved, "Product should be retrievable by ID");
//        assertEquals(testProduct.getTitle(), retrieved.getTitle());
//    }
//
//    @Test
//    void testGetAllProductsSuccess() throws Exception {
//        List<Product> products = productDAO.getAllProducts(true);
//        assertNotNull(products);
//        assertTrue(products.size() > 0, "There should be at least one active product");
//    }
//
//    @Test
//    void testUpdateProductSuccess() throws Exception {
//        testProduct.setPrice(60.0);
//        productDAO.updateProduct(testProduct);
//
//        Product updated = productDAO.getProductById(testProduct.getProductId());
//        assertEquals(60.0, updated.getPrice());
//    }

//
//    @Test
//    void testSaveProductWithNegativePrice() {
//        testProduct.setPrice(-100.0);
//
//        Exception ex = assertThrows(IllegalArgumentException.class, () -> productDAO.saveProduct(testProduct));
//        assertTrue(ex.getMessage().contains("Price cannot be negative"),
//                   "Saving product with negative price should fail");
//    }

    @Test
    void testSaveProductWithNullTitle() {
        testProduct.setTitle(null);

        Exception ex = assertThrows(IllegalArgumentException.class, () -> productDAO.saveProduct(testProduct));
        assertTrue(ex.getMessage().contains("Product title cannot be empty"),
                   "Saving product with null title should fail");
    }

//
//    @Test
//    void testUpdateProductWithInvalidId() {
//        testProduct.setProductId(-1L);
//
//        Exception ex = assertThrows(Exception.class, () -> productDAO.updateProduct(testProduct));
//        assertTrue(ex.getMessage().contains("Updating product failed"), "Updating non-existent product should fail");
//    }


}
