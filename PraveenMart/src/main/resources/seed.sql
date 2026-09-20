MERGE INTO users (name, email, password_hash, role) KEY(email)
VALUES
    ('Admin User', 'admin@praveenmart.com', '$2a$10$71gV/GvK/cPjp9JSspIF..MGh8ONmLjGn4YL.T44bRxG7rMvBVsT.', 'ADMIN');

INSERT INTO products (seller_id, name, description, price, stock_qty, category, image_url)
VALUES
    -- ==================== ELECTRONICS ====================
    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Wireless Bluetooth Headphones',
     'Over-ear wireless headphones with cushioned earcups, deep bass sound, and 30 hours of battery life.',
     1499.00, 25, 'Electronics',
     '/images/wireless_headphones.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Mechanical Gaming Keyboard',
     'Compact computer keyboard with tactile mechanical switches, fast response time, and RGB rainbow backlighting.',
     1299.00, 30, 'Electronics',
     '/images/gaming_keyboard.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Wireless Optical Mouse',
     'Ergonomic wireless mouse with smooth optical tracking, silent click buttons, and comfortable hand grip.',
     499.00, 40, 'Electronics',
     '/images/optical_mouse.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Portable Bluetooth Speaker',
     'Compact wireless speaker with rich 360-degree stereo sound, water-resistant body, and 12-hour playtime.',
     899.00, 35, 'Electronics',
     '/images/bluetooth_speaker.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Full HD Streaming Webcam',
     '1080p high-definition USB webcam with built-in noise-reducing microphone, ideal for video calls and online meetings.',
     999.00, 22, 'Electronics',
     '/images/webcam.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Slim Portable Power Bank',
     '10,000mAh external battery charger with dual USB fast-charging ports for phones and tablets.',
     799.00, 50, 'Electronics',
     '/images/power_bank.jpg'),

    -- ==================== FASHION & STYLE ====================
    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Classic White Cotton T-Shirt',
     'Breathable everyday round-neck t-shirt crafted from 100% combed soft cotton for casual comfort.',
     399.00, 50, 'Fashion & Style',
     '/images/white_tshirt.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Fleece Pullover Hoodie',
     'Warm and cozy long-sleeve hooded sweatshirt with a front kangaroo pocket and soft inner fleece lining.',
     899.00, 40, 'Fashion & Style',
     '/images/fleece_hoodie.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Classic Blue Denim Jacket',
     'Vintage-style blue denim jacket with brass front buttons, chest flap pockets, and sturdy stitching.',
     1299.00, 20, 'Fashion & Style',
     '/images/denim_jacket.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Slim Fit Denim Jeans',
     'Durable blue jeans made from stretch denim with a modern slim fit and classic five-pocket design.',
     999.00, 35, 'Fashion & Style',
     '/images/denim_jeans.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Genuine Leather Casual Belt',
     'Sturdy black genuine leather belt with an engraved silver metal buckle for everyday styling.',
     499.00, 40, 'Fashion & Style',
     '/images/leather_belt.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'White Low-Top Casual Sneakers',
     'Clean low-profile white lace-up sneakers with cushioned rubber soles for all-day comfort.',
     1499.00, 25, 'Fashion & Style',
     '/images/white_sneakers.jpg'),

    -- ==================== HOME & KITCHEN ====================
    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Electric Water Kettle',
     'Rapid-boil 1.7-liter stainless steel electric kettle with auto shut-off safety and boil-dry protection.',
     749.00, 30, 'Home & Kitchen',
     '/images/electric_kettle.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Natural Bamboo Cutting Board',
     'Organic wooden chopping board with side handles and juice grooves for slicing fruits, vegetables, and bread.',
     299.00, 45, 'Home & Kitchen',
     '/images/bamboo_cutting_board.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Cast Iron Cooking Skillet',
     'Heavy-duty pre-seasoned cast iron frying pan for searing steaks, sautéing vegetables, and stovetop baking.',
     899.00, 20, 'Home & Kitchen',
     '/images/cast_iron_skillet.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Glass Pour-Over Coffee Maker',
     'Handcrafted heat-resistant borosilicate glass coffee dripper with polished wooden collar and leather tie.',
     649.00, 25, 'Home & Kitchen',
     '/images/coffee_maker.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Stainless Steel Kitchen Knife Set',
     'Multi-piece high-carbon stainless steel chef knife set with ergonomic wooden handles and storage roll.',
     1199.00, 18, 'Home & Kitchen',
     '/images/chef_knife.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Ceramic Dinner Plate & Bowl Set',
     'Set of durable matte ceramic dinner plates and bowls suitable for everyday meals, salads, and pasta.',
     899.00, 22, 'Home & Kitchen',
     '/images/ceramic_bowls.jpg'),

    -- ==================== ACCESSORIES ====================
    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Classic Polarized Sunglasses',
     'Timeless gold wire frame sunglasses with UV400 protective polarized lenses and clear optics.',
     499.00, 40, 'Accessories',
     '/images/polarized_sunglasses.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Genuine Leather Bifold Wallet',
     'Handcrafted brown genuine leather pocket wallet featuring RFID shielding and multiple card slots.',
     399.00, 50, 'Accessories',
     '/images/leather_wallet.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Stainless Steel Insulated Bottle',
     'Double-wall vacuum insulated matte green water flask that keeps drinks icy cold or steaming hot.',
     349.00, 50, 'Accessories',
     '/images/insulated_tumbler.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Waterproof Commuter Laptop Backpack',
     'Roomy everyday backpack with padded 15.6-inch laptop compartment and weather-resistant fabric.',
     1099.00, 30, 'Accessories',
     '/images/laptop_backpack.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Luxury Quartz Wristwatch',
     'Sophisticated analog wristwatch with a white dial, sub-dials, and genuine brown embossed leather strap.',
     1399.00, 20, 'Accessories',
     '/images/quartz_watch.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Windproof Compact Folding Umbrella',
     'Automatic folding umbrella with reinforced windproof ribs, comfortable handle, and water-shedding canopy.',
     349.00, 40, 'Accessories',
     '/images/travel_umbrella.jpg');
