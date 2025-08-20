package com.pahanaedu.daotest;

import com.pahanaedu.config.DBConnection;
import com.pahanaedu.dao.OrderDAO;
import com.pahanaedu.dao.UserDAO;
import com.pahanaedu.model.Order;
import com.pahanaedu.model.OrderItem;
import com.pahanaedu.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.sql.Connection;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

public class OrderDAOTest {

    private OrderDAO orderDAO;
    private UserDAO userDAO;
    private User testCustomer;
    private User testCreator;
    private List<Long> createdOrderIds = new ArrayList<>();

    @BeforeEach
    void setUp() throws Exception {
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();

        // Unique emails per test run
        String customerEmail = "ordercustomer" + System.currentTimeMillis() + "@example.com";
        String creatorEmail = "ordercreator" + System.currentTimeMillis() + "@example.com";

        // Create test customer
        testCustomer = new User();
        testCustomer.setEmail(customerEmail);
        testCustomer.setPassword("pass123");
        testCustomer.setFirstName("Order");
        testCustomer.setLastName("Customer");
        testCustomer.setRole("customer");
        testCustomer.setActive(true);
        userDAO.saveUser(testCustomer);

        // Create test creator 
        testCreator = new User();
        testCreator.setEmail(creatorEmail);
        testCreator.setPassword("pass123");
        testCreator.setFirstName("Order");
        testCreator.setLastName("Creator");
        testCreator.setRole("staff");
        testCreator.setActive(true);
        userDAO.saveUser(testCreator);
    }

    @Test
    void testCreateOrderAndRetrieve() throws Exception {
        String billNumber = orderDAO.generateBillNumber();

        Order order = new Order();
        order.setCustomerId(testCustomer.getId());
        order.setCreatedBy(testCreator.getId());
        order.setTotalAmount(100.0);
        order.setStatus("pending");
        order.setBillNumber(billNumber);

        Long orderId = orderDAO.createOrder(order);
        createdOrderIds.add(orderId);

        assertNotNull(orderId, "Order ID should be generated");

        Order retrieved = orderDAO.getOrderById(orderId);
        assertNotNull(retrieved, "Order should be retrievable by ID");
        assertEquals(order.getTotalAmount(), retrieved.getTotalAmount());
        assertEquals(testCustomer.getId(), retrieved.getCustomerId());
    }

    @Test
    void testAddOrderItem() throws Exception {
        String billNumber = orderDAO.generateBillNumber();

        Order order = new Order();
        order.setCustomerId(testCustomer.getId());
        order.setCreatedBy(testCreator.getId());
        order.setTotalAmount(50.0);
        order.setStatus("pending");
        order.setBillNumber(billNumber);

        Long orderId = orderDAO.createOrder(order);
        createdOrderIds.add(orderId);

        OrderItem item = new OrderItem();
        item.setOrderId(orderId);
        item.setProductId(1L); 
        item.setQuantity(2);
        item.setUnitPrice(25.0);
        item.setDiscountPercentage(0.0);

        assertDoesNotThrow(() -> orderDAO.addOrderItem(item));

        Order retrieved = orderDAO.getOrderById(orderId);
        assertNotNull(retrieved.getItems());
        assertEquals(1, retrieved.getItems().size(), "Order should contain 1 item");
    }

    @Test
    void testGenerateBillNumber() throws Exception {
        String billNumber = orderDAO.generateBillNumber();
        assertNotNull(billNumber);
        assertTrue(billNumber.startsWith("BIL-"));
    }

    @Test
    void testGetAllOrders() throws Exception {
        List<Order> orders = orderDAO.getAllOrders();
        assertNotNull(orders);
        assertTrue(orders.size() >= 0);
    }

    @Test
    public void testAddOrderItemFailDuplicate() throws Exception {
    	Connection conn = DBConnection.getInstance().getConnection();
        conn.setAutoCommit(false);

        try {
            //Create an order
            String billNumber = orderDAO.generateBillNumber();
            Order order = new Order();
            order.setCustomerId(testCustomer.getId());
            order.setCreatedBy(testCreator.getId());
            order.setTotalAmount(100.0);
            order.setStatus("pending");
            order.setBillNumber(billNumber);

            Long orderId = orderDAO.createOrder(order);

            //Create an order item
            OrderItem item = new OrderItem();
            item.setOrderId(orderId);
            item.setProductId(1L);
            item.setQuantity(5);
            item.setUnitPrice(20.0);
            item.setDiscountPercentage(0.0);

            orderDAO.addOrderItem(item);

            Exception ex = assertThrows(Exception.class, () -> orderDAO.addOrderItem(item));
            assertTrue(ex.getMessage().contains("duplicate") || ex.getMessage().contains("already exists"),
                "Duplicate order item should throw exception");

        } finally {
            conn.rollback();
            conn.setAutoCommit(true);
        }
    }
}
