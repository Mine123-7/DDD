-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 03, 2025 at 04:30 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jazz_bar_cafe`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `CreateOrder` (IN `p_customer_name` VARCHAR(200), IN `p_customer_phone` VARCHAR(20), IN `p_customer_email` VARCHAR(200), IN `p_customer_address` TEXT, IN `p_payment_method` ENUM('cash','credit','transfer'), IN `p_special_notes` TEXT, IN `p_total_amount` DECIMAL(10,2), OUT `p_order_id` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMenuByCategory` (IN `category_id` INT)   BEGIN
    SELECT mi.*, c.name_th as category_name
    FROM menu_items mi
    JOIN categories c ON mi.category_id = c.id
    WHERE mi.category_id = category_id AND mi.is_available = TRUE
    ORDER BY mi.is_popular DESC, mi.name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetOrderDetails` (IN `p_order_id` INT)   BEGIN
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
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `name_th` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `name_th`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Cocktails', 'ค็อกเทล', 'เครื่องดื่มผสมที่มีแอลกอฮอล์', '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(2, 'Whiskey', 'วิสกี้', 'เครื่องดื่มแอลกอฮอล์ที่ได้จากการกลั่น', '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(3, 'Wine', 'ไวน์', 'เครื่องดื่มแอลกอฮอล์ที่ได้จากการหมักองุ่น', '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(4, 'Appetizers', 'อาหารเรียกน้ำย่อย', 'อาหารเบาๆ ก่อนมื้อหลัก', '2025-08-03 02:30:21', '2025-08-03 02:30:21');

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(200) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `name` varchar(200) NOT NULL,
  `category_id` int(11) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `image_url` varchar(500) DEFAULT NULL,
  `is_popular` tinyint(1) DEFAULT 0,
  `is_available` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`id`, `name`, `category_id`, `price`, `description`, `image_url`, `is_popular`, `is_available`, `created_at`, `updated_at`) VALUES
(1, 'Mojito', 1, 280.00, 'ค็อกเทลคลาสสิกที่ผสมผสานระหว่างรัมขาว มิ้นต์ มะนาว และโซดา', '🍹', 1, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(2, 'Margarita', 1, 320.00, 'ค็อกเทลเม็กซิกันที่ทำจากเตกิล่า มะนาว และคูราเซา', '🍸', 1, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(3, 'Martini', 1, 350.00, 'ค็อกเทลหรูหราที่ทำจากจินและเวอร์มัท เสิร์ฟพร้อมมะกอก', '🍸', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(4, 'Old Fashioned', 1, 380.00, 'ค็อกเทลคลาสสิกที่ทำจากวิสกี้ บิตเตอร์ และน้ำตาล', '🥃', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(5, 'Negroni', 1, 360.00, 'ค็อกเทลอิตาเลียนที่ผสมผสานระหว่างจิน เวอร์มัท และคัมปารี', '🍷', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(6, 'Jack Daniel\'s', 2, 450.00, 'วิสกี้เทนเนสซีที่โด่งดังทั่วโลก รสชาติเข้มข้นและนุ่มนวล', '🥃', 1, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(7, 'Johnnie Walker Black', 2, 520.00, 'สกอตช์วิสกี้พรีเมียมที่มีรสชาติซับซ้อนและกลมกล่อม', '🥃', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(8, 'Macallan 12', 2, 850.00, 'สกอตช์วิสกี้ชั้นสูงที่บ่มในถังโอ๊ค รสชาติหวานและมีกลิ่นหอม', '🥃', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(9, 'Bulleit Bourbon', 2, 480.00, 'บอร์บอนวิสกี้อเมริกันที่มีรสชาติเข้มข้นและมีกลิ่นหอมของวานิลลา', '🥃', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(10, 'Château Margaux', 3, 2800.00, 'ไวน์แดงชั้นสูงจากบอร์โดซ์ ประเทศฝรั่งเศส รสชาติซับซ้อนและมีกลิ่นหอม', '🍷', 1, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(11, 'Dom Pérignon', 3, 3500.00, 'แชมเปญพรีเมียมที่มีฟองละเอียดและรสชาติกลมกล่อม', '🍾', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(12, 'Barolo DOCG', 3, 1800.00, 'ไวน์แดงอิตาเลียนที่มีรสชาติเข้มข้นและมีกลิ่นหอมของผลไม้', '🍷', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(13, 'Sauvignon Blanc', 3, 650.00, 'ไวน์ขาวที่มีรสชาติสดชื่นและมีกลิ่นหอมของผลไม้รสเปรี้ยว', '🍷', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(14, 'Truffle Fries', 4, 180.00, 'เฟรนช์ฟรายส์ที่โรยด้วยเกลือทรัฟเฟิลและชีสพาร์เมซาน', '🍟', 1, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(15, 'Bruschetta', 4, 220.00, 'ขนมปังปิ้งที่ทาด้วยมะเขือเทศ กระเทียม และใบโหระพา', '🥖', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(16, 'Cheese Platter', 4, 450.00, 'จานชีสหลากหลายชนิดพร้อมผลไม้แห้งและถั่ว', '🧀', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(17, 'Oysters Rockefeller', 4, 380.00, 'หอยนางรมที่อบด้วยเนย ใบโหระพา และชีส', '🦪', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(18, 'Caviar Service', 4, 1200.00, 'คาเวียร์พรีเมียมเสิร์ฟพร้อมขนมปังปิ้งและครีม', '🐟', 0, 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `order_number` varchar(50) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_method` enum('cash','credit','transfer') NOT NULL,
  `order_status` enum('pending','confirmed','preparing','ready','delivered','cancelled') DEFAULT 'pending',
  `special_notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `orders`
--
DELIMITER $$
CREATE TRIGGER `order_status_audit` AFTER UPDATE ON `orders` FOR EACH ROW BEGIN
    IF OLD.order_status != NEW.order_status THEN
        INSERT INTO order_audit (order_id, action, old_status, new_status)
        VALUES (NEW.id, 'STATUS_CHANGE', OLD.order_status, NEW.order_status);
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `order_audit`
--

CREATE TABLE `order_audit` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `action` varchar(50) NOT NULL,
  `old_status` varchar(50) DEFAULT NULL,
  `new_status` varchar(50) DEFAULT NULL,
  `changed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `menu_item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `unit_price` decimal(10,2) NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `order_summary`
-- (See below for the actual view)
--
CREATE TABLE `order_summary` (
`id` int(11)
,`order_number` varchar(50)
,`total_amount` decimal(10,2)
,`order_status` enum('pending','confirmed','preparing','ready','delivered','cancelled')
,`created_at` timestamp
,`customer_name` varchar(200)
,`customer_phone` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `popular_items`
-- (See below for the actual view)
--
CREATE TABLE `popular_items` (
`id` int(11)
,`name` varchar(200)
,`category_id` int(11)
,`price` decimal(10,2)
,`description` text
,`image_url` varchar(500)
,`is_popular` tinyint(1)
,`is_available` tinyint(1)
,`created_at` timestamp
,`updated_at` timestamp
,`category_name` varchar(100)
);

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL,
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `discount_percent` decimal(5,2) DEFAULT NULL,
  `discount_amount` decimal(10,2) DEFAULT NULL,
  `promo_code` varchar(50) DEFAULT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promotions`
--

INSERT INTO `promotions` (`id`, `title`, `description`, `discount_percent`, `discount_amount`, `promo_code`, `start_date`, `end_date`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Welcome Discount', 'ส่วนลดต้อนรับสำหรับลูกค้าใหม่', 10.00, NULL, 'WELCOME10', '2025-08-03 09:30:21', '2025-09-02 09:30:21', 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21'),
(2, 'Cocktail Special', 'ซื้อ 2 แก้ว รับส่วนลด 20% สำหรับค็อกเทลทั้งหมด', 20.00, NULL, 'COCKTAIL20', '2025-08-03 09:30:21', '2025-08-10 09:30:21', 1, '2025-08-03 02:30:21', '2025-08-03 02:30:21');

-- --------------------------------------------------------

--
-- Structure for view `order_summary`
--
DROP TABLE IF EXISTS `order_summary`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `order_summary`  AS SELECT `o`.`id` AS `id`, `o`.`order_number` AS `order_number`, `o`.`total_amount` AS `total_amount`, `o`.`order_status` AS `order_status`, `o`.`created_at` AS `created_at`, `c`.`name` AS `customer_name`, `c`.`phone` AS `customer_phone` FROM (`orders` `o` join `customers` `c` on(`o`.`customer_id` = `c`.`id`)) ORDER BY `o`.`created_at` DESC ;

-- --------------------------------------------------------

--
-- Structure for view `popular_items`
--
DROP TABLE IF EXISTS `popular_items`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `popular_items`  AS SELECT `mi`.`id` AS `id`, `mi`.`name` AS `name`, `mi`.`category_id` AS `category_id`, `mi`.`price` AS `price`, `mi`.`description` AS `description`, `mi`.`image_url` AS `image_url`, `mi`.`is_popular` AS `is_popular`, `mi`.`is_available` AS `is_available`, `mi`.`created_at` AS `created_at`, `mi`.`updated_at` AS `updated_at`, `c`.`name_th` AS `category_name` FROM (`menu_items` `mi` join `categories` `c` on(`mi`.`category_id` = `c`.`id`)) WHERE `mi`.`is_popular` = 1 AND `mi`.`is_available` = 1 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_menu_items_category` (`category_id`),
  ADD KEY `idx_menu_items_popular` (`is_popular`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `order_number` (`order_number`),
  ADD KEY `idx_orders_customer` (`customer_id`),
  ADD KEY `idx_orders_status` (`order_status`);

--
-- Indexes for table `order_audit`
--
ALTER TABLE `order_audit`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `menu_item_id` (`menu_item_id`),
  ADD KEY `idx_order_items_order` (`order_id`);

--
-- Indexes for table `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `promo_code` (`promo_code`),
  ADD KEY `idx_promotions_active` (`is_active`,`start_date`,`end_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_audit`
--
ALTER TABLE `order_audit`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `menu_items_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
