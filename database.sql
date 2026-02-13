-- Jazz Bar Café Database Schema
-- Created for online ordering system

-- Create database
CREATE DATABASE IF NOT EXISTS jazz_bar_cafe;
USE jazz_bar_cafe;

-- Create tables
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    name_th VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    category_id INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    image_url VARCHAR(500),
    is_popular BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(200) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(200),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('cash', 'credit', 'transfer') NOT NULL,
    order_status ENUM('pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled') DEFAULT 'pending',
    special_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS promotions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    discount_percent DECIMAL(5,2),
    discount_amount DECIMAL(10,2),
    promo_code VARCHAR(50) UNIQUE,
    start_date DATETIME,
    end_date DATETIME,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert sample data

-- Categories
INSERT INTO categories (name, name_th, description) VALUES
('Cocktails', 'ค็อกเทล', 'เครื่องดื่มผสมที่มีแอลกอฮอล์'),
('Whiskey', 'วิสกี้', 'เครื่องดื่มแอลกอฮอล์ที่ได้จากการกลั่น'),
('Wine', 'ไวน์', 'เครื่องดื่มแอลกอฮอล์ที่ได้จากการหมักองุ่น'),
('Appetizers', 'อาหารเรียกน้ำย่อย', 'อาหารเบาๆ ก่อนมื้อหลัก');

-- Menu Items
INSERT INTO menu_items (name, category_id, price, description, image_url, is_popular) VALUES
-- Cocktails
('Mojito', 1, 280.00, 'ค็อกเทลคลาสสิกที่ผสมผสานระหว่างรัมขาว มิ้นต์ มะนาว และโซดา', '🍹', TRUE),
('Margarita', 1, 320.00, 'ค็อกเทลเม็กซิกันที่ทำจากเตกิล่า มะนาว และคูราเซา', '🍸', TRUE),
('Martini', 1, 350.00, 'ค็อกเทลหรูหราที่ทำจากจินและเวอร์มัท เสิร์ฟพร้อมมะกอก', '🍸', FALSE),
('Old Fashioned', 1, 380.00, 'ค็อกเทลคลาสสิกที่ทำจากวิสกี้ บิตเตอร์ และน้ำตาล', '🥃', FALSE),
('Negroni', 1, 360.00, 'ค็อกเทลอิตาเลียนที่ผสมผสานระหว่างจิน เวอร์มัท และคัมปารี', '🍷', FALSE),

-- Whiskey
('Jack Daniel\'s', 2, 450.00, 'วิสกี้เทนเนสซีที่โด่งดังทั่วโลก รสชาติเข้มข้นและนุ่มนวล', '🥃', TRUE),
('Johnnie Walker Black', 2, 520.00, 'สกอตช์วิสกี้พรีเมียมที่มีรสชาติซับซ้อนและกลมกล่อม', '🥃', FALSE),
('Macallan 12', 2, 850.00, 'สกอตช์วิสกี้ชั้นสูงที่บ่มในถังโอ๊ค รสชาติหวานและมีกลิ่นหอม', '🥃', FALSE),
('Bulleit Bourbon', 2, 480.00, 'บอร์บอนวิสกี้อเมริกันที่มีรสชาติเข้มข้นและมีกลิ่นหอมของวานิลลา', '🥃', FALSE),

-- Wine
('Château Margaux', 3, 2800.00, 'ไวน์แดงชั้นสูงจากบอร์โดซ์ ประเทศฝรั่งเศส รสชาติซับซ้อนและมีกลิ่นหอม', '🍷', TRUE),
('Dom Pérignon', 3, 3500.00, 'แชมเปญพรีเมียมที่มีฟองละเอียดและรสชาติกลมกล่อม', '🍾', FALSE),
('Barolo DOCG', 3, 1800.00, 'ไวน์แดงอิตาเลียนที่มีรสชาติเข้มข้นและมีกลิ่นหอมของผลไม้', '🍷', FALSE),
('Sauvignon Blanc', 3, 650.00, 'ไวน์ขาวที่มีรสชาติสดชื่นและมีกลิ่นหอมของผลไม้รสเปรี้ยว', '🍷', FALSE),

-- Appetizers
('Truffle Fries', 4, 180.00, 'เฟรนช์ฟรายส์ที่โรยด้วยเกลือทรัฟเฟิลและชีสพาร์เมซาน', '🍟', TRUE),
('Bruschetta', 4, 220.00, 'ขนมปังปิ้งที่ทาด้วยมะเขือเทศ กระเทียม และใบโหระพา', '🥖', FALSE),
('Cheese Platter', 4, 450.00, 'จานชีสหลากหลายชนิดพร้อมผลไม้แห้งและถั่ว', '🧀', FALSE),
('Oysters Rockefeller', 4, 380.00, 'หอยนางรมที่อบด้วยเนย ใบโหระพา และชีส', '🦪', FALSE),
('Caviar Service', 4, 1200.00, 'คาเวียร์พรีเมียมเสิร์ฟพร้อมขนมปังปิ้งและครีม', '🐟', FALSE);

-- Sample Customers
INSERT INTO customers (name, phone, email, address) VALUES
('สมชาย ใจดี', '0812345678', 'somchai@email.com', '123 ถนนสุขุมวิท แขวงคลองเตย เขตคลองเตย กรุงเทพฯ 10110'),
('สมหญิง รักดี', '0823456789', 'somying@email.com', '456 ถนนรัชดาภิเษก แขวงดินแดง เขตดินแดง กรุงเทพฯ 10400'),
('วิชัย มั่งมี', '0834567890', 'wichai@email.com', '789 ถนนเพชรบุรี แขวงทุ่งพญาไท เขตราชเทวี กรุงเทพฯ 10400'),
('รัตนา สวยงาม', '0845678901', 'rattana@email.com', '321 ถนนพระราม 9 แขวงห้วยขวาง เขตห้วยขวาง กรุงเทพฯ 10310'),
('ธนวัฒน์ รวยดี', '0856789012', 'thanawat@email.com', '654 ถนนลาดพร้าว แขวงลาดพร้าว เขตลาดพร้าว กรุงเทพฯ 10230'),
('นิตยา น่ารัก', '0867890123', 'nitya@email.com', '987 ถนนวิภาวดีรังสิต แขวงดินแดง เขตดินแดง กรุงเทพฯ 10400'),
('อภิชาติ เก่งดี', '0878901234', 'apichat@email.com', '147 ถนนรัชดาภิเษก แขวงดินแดง เขตดินแดง กรุงเทพฯ 10400'),
('สุภาพร อ่อนโยน', '0889012345', 'supaporn@email.com', '258 ถนนสุขุมวิท แขวงคลองเตย เขตคลองเตย กรุงเทพฯ 10110'),
('ชัยวัฒน์ ใจเย็น', '0890123456', 'chaiwat@email.com', '369 ถนนเพชรบุรี แขวงทุ่งพญาไท เขตราชเทวี กรุงเทพฯ 10400'),
('รัชดา สดใส', '0891234567', 'rachada@email.com', '741 ถนนพระราม 9 แขวงห้วยขวาง เขตห้วยขวาง กรุงเทพฯ 10310');

-- Sample Orders with various statuses and dates
INSERT INTO orders (order_number, customer_id, total_amount, payment_method, order_status, special_notes, created_at) VALUES
('JB20241201001', 1, 760.00, 'cash', 'delivered', 'เสิร์ฟที่โต๊ะ 5', '2024-12-01 18:30:00'),
('JB20241201002', 2, 1200.00, 'transfer', 'delivered', 'ห่อกลับบ้าน', '2024-12-01 19:15:00'),
('JB20241201003', 3, 1850.00, 'credit', 'delivered', 'เสิร์ฟที่โต๊ะ VIP', '2024-12-01 20:00:00'),
('JB20241201004', 4, 680.00, 'cash', 'delivered', 'เสิร์ฟที่บาร์', '2024-12-01 21:30:00'),
('JB20241201005', 5, 930.00, 'transfer', 'delivered', 'ห่อกลับบ้าน', '2024-12-01 22:15:00'),
('JB20241202001', 6, 1560.00, 'credit', 'delivered', 'เสิร์ฟที่โต๊ะ 3', '2024-12-02 18:45:00'),
('JB20241202002', 7, 420.00, 'cash', 'delivered', 'เสิร์ฟที่บาร์', '2024-12-02 19:30:00'),
('JB20241202003', 8, 890.00, 'transfer', 'delivered', 'ห่อกลับบ้าน', '2024-12-02 20:45:00'),
('JB20241202004', 9, 2100.00, 'credit', 'delivered', 'เสิร์ฟที่โต๊ะ VIP', '2024-12-02 21:15:00'),
('JB20241202005', 10, 740.00, 'cash', 'delivered', 'เสิร์ฟที่โต๊ะ 2', '2024-12-02 22:00:00'),
('JB20241203001', 1, 580.00, 'cash', 'ready', 'เสิร์ฟที่โต๊ะ 1', '2024-12-03 18:20:00'),
('JB20241203002', 2, 1100.00, 'transfer', 'preparing', 'ห่อกลับบ้าน', '2024-12-03 19:00:00'),
('JB20241203003', 3, 1650.00, 'credit', 'confirmed', 'เสิร์ฟที่โต๊ะ VIP', '2024-12-03 19:45:00'),
('JB20241203004', 4, 820.00, 'cash', 'pending', 'เสิร์ฟที่บาร์', '2024-12-03 20:30:00'),
('JB20241203005', 5, 1340.00, 'transfer', 'pending', 'ห่อกลับบ้าน', '2024-12-03 21:15:00');

-- Sample Order Items with realistic quantities and popular items
INSERT INTO order_items (order_id, menu_item_id, quantity, unit_price, total_price) VALUES
-- Order 1: สมชาย - 2 items
(1, 1, 2, 280.00, 560.00),  -- Mojito x2
(1, 20, 1, 200.00, 200.00), -- Truffle Fries

-- Order 2: สมหญิง - 3 items  
(2, 6, 1, 450.00, 450.00),  -- Jack Daniel's
(2, 20, 1, 180.00, 180.00), -- Truffle Fries
(2, 21, 1, 220.00, 220.00), -- Bruschetta
(2, 22, 1, 350.00, 350.00), -- Cheese Platter

-- Order 3: วิชัย - 4 items
(3, 10, 1, 2800.00, 2800.00), -- Château Margaux
(3, 20, 1, 180.00, 180.00),   -- Truffle Fries
(3, 21, 1, 220.00, 220.00),   -- Bruschetta
(3, 22, 1, 450.00, 450.00),   -- Cheese Platter

-- Order 4: รัตนา - 2 items
(4, 1, 1, 280.00, 280.00),   -- Mojito
(4, 20, 1, 180.00, 180.00),  -- Truffle Fries
(4, 21, 1, 220.00, 220.00),  -- Bruschetta

-- Order 5: ธนวัฒน์ - 3 items
(5, 6, 1, 450.00, 450.00),   -- Jack Daniel's
(5, 20, 1, 180.00, 180.00),  -- Truffle Fries
(5, 21, 1, 220.00, 220.00),  -- Bruschetta
(5, 22, 1, 80.00, 80.00),    -- Cheese Platter

-- Order 6: นิตยา - 4 items
(6, 1, 2, 280.00, 560.00),   -- Mojito x2
(6, 6, 1, 450.00, 450.00),   -- Jack Daniel's
(6, 20, 1, 180.00, 180.00),  -- Truffle Fries
(6, 21, 1, 220.00, 220.00),  -- Bruschetta
(6, 22, 1, 150.00, 150.00),  -- Cheese Platter

-- Order 7: อภิชาติ - 1 item
(7, 20, 1, 180.00, 180.00),  -- Truffle Fries
(7, 21, 1, 240.00, 240.00),  -- Bruschetta

-- Order 8: สุภาพร - 3 items
(8, 1, 1, 280.00, 280.00),   -- Mojito
(8, 20, 1, 180.00, 180.00),  -- Truffle Fries
(8, 21, 1, 220.00, 220.00),  -- Bruschetta
(8, 22, 1, 210.00, 210.00),  -- Cheese Platter

-- Order 9: ชัยวัฒน์ - 5 items
(9, 10, 1, 2800.00, 2800.00), -- Château Margaux
(9, 20, 1, 180.00, 180.00),   -- Truffle Fries
(9, 21, 1, 220.00, 220.00),   -- Bruschetta
(9, 22, 1, 450.00, 450.00),   -- Cheese Platter
(9, 23, 1, 380.00, 380.00),   -- Oysters Rockefeller
(9, 24, 1, 1200.00, 1200.00), -- Caviar Service

-- Order 10: รัชดา - 2 items
(10, 1, 1, 280.00, 280.00),  -- Mojito
(10, 20, 1, 180.00, 180.00), -- Truffle Fries
(10, 21, 1, 280.00, 280.00), -- Bruschetta

-- Order 11: สมชาย (return customer) - 2 items
(11, 2, 1, 320.00, 320.00),  -- Margarita
(11, 20, 1, 180.00, 180.00), -- Truffle Fries
(11, 21, 1, 80.00, 80.00),   -- Bruschetta

-- Order 12: สมหญิง (return customer) - 3 items
(12, 6, 1, 450.00, 450.00),  -- Jack Daniel's
(12, 20, 1, 180.00, 180.00), -- Truffle Fries
(12, 21, 1, 220.00, 220.00), -- Bruschetta
(12, 22, 1, 250.00, 250.00), -- Cheese Platter

-- Order 13: วิชัย (return customer) - 4 items
(13, 10, 1, 2800.00, 2800.00), -- Château Margaux
(13, 20, 1, 180.00, 180.00),   -- Truffle Fries
(13, 21, 1, 220.00, 220.00),   -- Bruschetta
(13, 22, 1, 450.00, 450.00),   -- Cheese Platter

-- Order 14: รัตนา (return customer) - 2 items
(14, 1, 1, 280.00, 280.00),  -- Mojito
(14, 20, 1, 180.00, 180.00), -- Truffle Fries
(14, 21, 1, 220.00, 220.00), -- Bruschetta
(14, 22, 1, 140.00, 140.00), -- Cheese Platter

-- Order 15: ธนวัฒน์ (return customer) - 3 items
(15, 6, 1, 450.00, 450.00),  -- Jack Daniel's
(15, 20, 1, 180.00, 180.00), -- Truffle Fries
(15, 21, 1, 220.00, 220.00), -- Bruschetta
(15, 22, 1, 490.00, 490.00); -- Cheese Platter

-- Promotions
INSERT INTO promotions (title, description, discount_percent, promo_code, start_date, end_date) VALUES
('Welcome Discount', 'ส่วนลดต้อนรับสำหรับลูกค้าใหม่', 10.00, 'WELCOME10', NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
('Cocktail Special', 'ซื้อ 2 แก้ว รับส่วนลด 20% สำหรับค็อกเทลทั้งหมด', 20.00, 'COCKTAIL20', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY));

-- Create indexes for better performance
CREATE INDEX idx_menu_items_category ON menu_items(category_id);
CREATE INDEX idx_menu_items_popular ON menu_items(is_popular);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_status ON orders(order_status);
CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_promotions_active ON promotions(is_active, start_date, end_date);

-- Create views for easier data access
CREATE VIEW popular_items AS
SELECT mi.*, c.name_th as category_name
FROM menu_items mi
JOIN categories c ON mi.category_id = c.id
WHERE mi.is_popular = TRUE AND mi.is_available = TRUE;

CREATE VIEW order_summary AS
SELECT 
    o.id,
    o.order_number,
    o.total_amount,
    o.order_status,
    o.created_at,
    c.name as customer_name,
    c.phone as customer_phone
FROM orders o
JOIN customers c ON o.customer_id = c.id
ORDER BY o.created_at DESC;

-- Create stored procedures
DELIMITER //

CREATE PROCEDURE GetMenuByCategory(IN category_id INT)
BEGIN
    SELECT mi.*, c.name_th as category_name
    FROM menu_items mi
    JOIN categories c ON mi.category_id = c.id
    WHERE mi.category_id = category_id AND mi.is_available = TRUE
    ORDER BY mi.is_popular DESC, mi.name;
END //

CREATE PROCEDURE CreateOrder(
    IN p_customer_name VARCHAR(200),
    IN p_customer_phone VARCHAR(20),
    IN p_customer_email VARCHAR(200),
    IN p_customer_address TEXT,
    IN p_payment_method ENUM('cash', 'credit', 'transfer'),
    IN p_special_notes TEXT,
    IN p_total_amount DECIMAL(10,2),
    OUT p_order_id INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_order_number VARCHAR(50);
    
    -- Generate order number
    SET v_order_number = CONCAT('JB', DATE_FORMAT(NOW(), '%Y%m%d'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- Insert or get customer
    INSERT INTO customers (name, phone, email, address)
    VALUES (p_customer_name, p_customer_phone, p_customer_email, p_customer_address)
    ON DUPLICATE KEY UPDATE id = LAST_INSERT_ID(id);
    
    SET v_customer_id = LAST_INSERT_ID();
    
    -- Create order
    INSERT INTO orders (order_number, customer_id, total_amount, payment_method, special_notes)
    VALUES (v_order_number, v_customer_id, p_total_amount, p_payment_method, p_special_notes);
    
    SET p_order_id = LAST_INSERT_ID();
    
    SELECT p_order_id as order_id, v_order_number as order_number;
END //

CREATE PROCEDURE GetOrderDetails(IN p_order_id INT)
BEGIN
    SELECT 
        o.order_number,
        o.total_amount,
        o.payment_method,
        o.order_status,
        o.special_notes,
        o.created_at,
        c.name as customer_name,
        c.phone as customer_phone,
        c.email as customer_email,
        c.address as customer_address
    FROM orders o
    JOIN customers c ON o.customer_id = c.id
    WHERE o.id = p_order_id;
    
    SELECT 
        mi.name as item_name,
        oi.quantity,
        oi.unit_price,
        oi.total_price
    FROM order_items oi
    JOIN menu_items mi ON oi.menu_item_id = mi.id
    WHERE oi.order_id = p_order_id;
END //

DELIMITER ;

-- Create triggers for audit trail
CREATE TABLE order_audit (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

CREATE TRIGGER order_status_audit
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.order_status != NEW.order_status THEN
        INSERT INTO order_audit (order_id, action, old_status, new_status)
        VALUES (NEW.id, 'STATUS_CHANGE', OLD.order_status, NEW.order_status);
    END IF;
END //

DELIMITER ;

-- Grant permissions (adjust as needed for your setup)
-- GRANT ALL PRIVILEGES ON jazz_bar_cafe.* TO 'jazzbar_user'@'localhost' IDENTIFIED BY 'your_password';
-- FLUSH PRIVILEGES;

-- Query to show menu item popularity (number of orders)
-- This query shows how many times each menu item has been ordered
SELECT 
    mi.id,
    mi.name,
    mi.name_th,
    c.name_th as category_name,
    mi.price,
    mi.is_popular,
    COUNT(oi.id) as order_count,
    SUM(oi.quantity) as total_quantity_ordered,
    SUM(oi.total_price) as total_revenue
FROM menu_items mi
LEFT JOIN categories c ON mi.category_id = c.id
LEFT JOIN order_items oi ON mi.id = oi.menu_item_id
GROUP BY mi.id, mi.name, mi.name_th, c.name_th, mi.price, mi.is_popular
ORDER BY order_count DESC, total_quantity_ordered DESC;

-- Alternative view for popular items with order statistics
CREATE VIEW menu_popularity AS
SELECT 
    mi.id,
    mi.name,
    mi.name_th,
    c.name_th as category_name,
    mi.price,
    mi.is_popular,
    COUNT(oi.id) as order_count,
    SUM(oi.quantity) as total_quantity_ordered,
    SUM(oi.total_price) as total_revenue,
    ROUND(AVG(oi.quantity), 1) as avg_quantity_per_order
FROM menu_items mi
LEFT JOIN categories c ON mi.category_id = c.id
LEFT JOIN order_items oi ON mi.id = oi.menu_item_id
GROUP BY mi.id, mi.name, mi.name_th, c.name_th, mi.price, mi.is_popular;

-- Query to show top selling items by category
SELECT 
    c.name_th as category_name,
    mi.name_th as item_name,
    COUNT(oi.id) as order_count,
    SUM(oi.quantity) as total_quantity,
    SUM(oi.total_price) as total_revenue
FROM categories c
JOIN menu_items mi ON c.id = mi.category_id
LEFT JOIN order_items oi ON mi.id = oi.menu_item_id
GROUP BY c.id, c.name_th, mi.id, mi.name_th
ORDER BY c.name_th, order_count DESC, total_quantity DESC; 