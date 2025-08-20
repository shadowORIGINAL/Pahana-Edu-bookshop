package com.pahanaedu.controllertest;

import com.pahanaedu.controller.ManageProductsServlet;
import com.pahanaedu.model.Product;
import com.pahanaedu.model.User;
import com.pahanaedu.service.ProductService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.util.List;

import static org.mockito.Mockito.*;

public class ManageProductsServletTest {

    private ManageProductsServlet servlet;
    private ProductService productService;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private RequestDispatcher dispatcher;
    private Part filePart;

    @BeforeEach
    void setUp() throws Exception {
        servlet = new ManageProductsServlet();

        productService = mock(ProductService.class);
        request = mock(HttpServletRequest.class);
        response = mock(HttpServletResponse.class);
        session = mock(HttpSession.class);
        dispatcher = mock(RequestDispatcher.class);
        filePart = mock(Part.class);

        // Inject mock ProductService into servlet
        var field = ManageProductsServlet.class.getDeclaredField("productService");
        field.setAccessible(true);
        field.set(servlet, productService);

        when(request.getSession(false)).thenReturn(session);
        when(request.getRequestDispatcher(anyString())).thenReturn(dispatcher);
    }

//    @Test
//    void testDoGet_AdminUser_ShowsProducts() throws Exception {
//        User admin = new User();
//        admin.setRole("ADMIN");
//        when(session.getAttribute("user")).thenReturn(admin);
//        when(productService.getAllProducts(false)).thenReturn(List.of(new Product()));
//
//        servlet.doGet(request, response);
//
//        verify(request).setAttribute(eq("productList"), anyList());
//        verify(dispatcher).forward(request, response);
//    }

    @Test
    void testDoGet_NonAdminUser_RedirectsToLogin() throws Exception {
        User user = new User();
        user.setRole("CUSTOMER");
        when(session.getAttribute("user")).thenReturn(user);

        servlet.doGet(request, response);

        verify(response).sendRedirect("login.jsp");  
    }
//
//    @Test
//    void testDeleteProduct_Success() throws Exception {
//        User admin = new User();
//        admin.setRole("ADMIN");
//        when(session.getAttribute("user")).thenReturn(admin);
//        when(request.getParameter("action")).thenReturn("delete");
//        when(request.getParameter("id")).thenReturn("1");
//
//        servlet.doPost(request, response);
//
//        verify(productService).deleteProduct(1L);
//        verify(response).sendRedirect(contains("success=Product+deleted"));
//    }
//
//    @Test
//    void testToggleProductStatus_Success() throws Exception {
//        User admin = new User();
//        admin.setRole("ADMIN");
//        when(session.getAttribute("user")).thenReturn(admin);
//        when(request.getParameter("action")).thenReturn("toggleActive");
//        when(request.getParameter("id")).thenReturn("1");
//
//        Product product = new Product();
//        product.setActive(true);
//        when(productService.getProductById(1L)).thenReturn(product);
//
//        servlet.doPost(request, response);
//
//        verify(productService).updateProduct(product);
//        verify(response).sendRedirect(contains("success=Product+status+updated"));
//    }
}
