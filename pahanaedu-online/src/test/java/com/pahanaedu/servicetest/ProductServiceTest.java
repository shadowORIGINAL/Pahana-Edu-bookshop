package com.pahanaedu.servicetest;

import com.pahanaedu.dao.ProductDAO;
import com.pahanaedu.model.Product;
import com.pahanaedu.service.ProductService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class ProductServiceTest {

    private ProductService productService;
    private ProductDAO productDAO;

    @BeforeEach
    void setUp() throws Exception {
        productService = ProductService.getInstance();
        productDAO = mock(ProductDAO.class);

        // Inject mock DAO via reflection
        var daoField = ProductService.class.getDeclaredField("productDAO");
        daoField.setAccessible(true);
        daoField.set(productService, productDAO);
    }

    // ✅ GREEN TESTS

    @Test
    void testAddProduct_Success() throws Exception {
        Product product = new Product();
        product.setTitle("Book");
        product.setPrice(100);

        productService.addProduct(product);

        verify(productDAO).saveProduct(product);
    }

//    @Test
//    void testGetAllProducts_Success() throws Exception {
//        Product product1 = new Product();
//        product1.setTitle("Book1");
//        Product product2 = new Product();
//        product2.setTitle("Book2");
//
//        when(productDAO.getAllProducts(true)).thenReturn(List.of(product1, product2));
//
//        List<Product> products = productService.getAllProducts(true);
//
//        assertEquals(2, products.size());
//        assertEquals("Book1", products.get(0).getTitle());
//        verify(productDAO).getAllProducts(true);
//    }
//
//    @Test
//    void testGetProductById_Success() throws Exception {
//        Product product = new Product();
//        product.setProductId(1L);
//        product.setTitle("Book");
//
//        when(productDAO.getProductById(1L)).thenReturn(product);
//
//        Product result = productService.getProductById(1L);
//
//        assertEquals(1L, result.getProductId());
//        assertEquals("Book", result.getTitle());
//        verify(productDAO).getProductById(1L);
//    }
//
//    @Test
//    void testUpdateProduct_Success() throws Exception {
//        Product product = new Product();
//        product.setProductId(1L);
//        product.setTitle("Book Updated");
//
//        productService.updateProduct(product);
//
//        verify(productDAO).updateProduct(product);
//    }
//
//    @Test
//    void testDeleteProduct_Success() throws Exception {
//        long id = 1L;
//
//        productService.deleteProduct(id);
//
//        verify(productDAO).deleteProduct(id);
//    }
//
//    // 🔴 RED TESTS (simulate DAO failures)
//
//    @Test
//    void testAddProduct_Failure() throws Exception {
//        Product product = new Product();
//        doThrow(new RuntimeException("DB error")).when(productDAO).saveProduct(product);
//
//        Exception ex = assertThrows(Exception.class, () -> productService.addProduct(product));
//        assertEquals("DB error", ex.getMessage());
//    }
//
//    @Test
//    void testGetAllProducts_Failure() throws Exception {
//        doThrow(new RuntimeException("DB error")).when(productDAO).getAllProducts(true);
//
//        Exception ex = assertThrows(Exception.class, () -> productService.getAllProducts(true));
//        assertEquals("DB error", ex.getMessage());
//    }
//
//    @Test
//    void testGetProductById_Failure() throws Exception {
//        doThrow(new RuntimeException("DB error")).when(productDAO).getProductById(1L);
//
//        Exception ex = assertThrows(Exception.class, () -> productService.getProductById(1L));
//        assertEquals("DB error", ex.getMessage());
//    }
//
//    @Test
//    void testUpdateProduct_Failure() throws Exception {
//        Product product = new Product();
//        doThrow(new RuntimeException("DB error")).when(productDAO).updateProduct(product);
//
//        Exception ex = assertThrows(Exception.class, () -> productService.updateProduct(product));
//        assertEquals("DB error", ex.getMessage());
//    }
//
//    @Test
//    void testDeleteProduct_Failure() throws Exception {
//        doThrow(new RuntimeException("DB error")).when(productDAO).deleteProduct(1L);
//
//        Exception ex = assertThrows(Exception.class, () -> productService.deleteProduct(1L));
//        assertEquals("DB error", ex.getMessage());
//    }
}
