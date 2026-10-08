MERGE INTO users (name, email, password_hash, role) KEY(email)
VALUES
    ('Admin User', 'admin@praveenmart.com', '$2a$10$71gV/GvK/cPjp9JSspIF..MGh8ONmLjGn4YL.T44bRxG7rMvBVsT.', 'ADMIN');

INSERT INTO products (seller_id, name, description, price, stock_qty, category, image_url)
VALUES
    -- ==================== ELECTRONICS ====================
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

    -- ==================== HOME & KITCHEN ====================
    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Electric Water Kettle',
     'Rapid-boil 1.7-liter stainless steel electric kettle with auto shut-off safety and boil-dry protection.',
     749.00, 30, 'Home & Kitchen',
     '/images/electric_kettle.jpg'),

    -- ==================== ACCESSORIES ====================
    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Waterproof Commuter Laptop Backpack',
     'Roomy everyday backpack with padded 15.6-inch laptop compartment and weather-resistant fabric.',
     1099.00, 4, 'Accessories',
     '/images/laptop_backpack.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Windproof Compact Folding Umbrella',
     'Automatic folding umbrella with reinforced windproof ribs, comfortable handle, and water-shedding canopy.',
     349.00, 40, 'Accessories',
     '/images/travel_umbrella.jpg'),

    -- ==================== NEW ARRIVALS ====================
    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Learning Data Science: Data Wrangling, Exploration, Visualization, and Modeling with Python',
     'Comprehensive guide by Sam Lau, Joseph Gonzalez, and Deborah Nolan (O''Reilly). Learn Python-based exploratory data analysis, wrangling, predictive modeling, and data visualization.',
     899.00, 25, 'Books',
     '/images/learning_data_science_book.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'New York Yankees ''47 Clean Up Two-Tone Cap',
     'Premium relaxed-fit baseball cap with raised embroidered New York Yankees NY crest, two-tone cream crown with brown curved brim, and adjustable strapback closure.',
     699.00, 30, 'Fashion & Style',
     '/images/ny_yankees_cap.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Bowers & Wilkins Px8 Wireless Noise-Cancelling Headphones',
     'Flagship high-resolution over-ear headphones featuring carbon cone drive units, hybrid active noise cancellation, luxury dark metallic finish with gold-copper accent plates, and plush memory foam.',
     4999.00, 15, 'Electronics',
     '/images/bowers_wilkins_headphones.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Granite Stone Non-Stick Cookware Set (10-Piece)',
     'Ultra-durable speckled granite non-stick pots and pans set with tempered glass vent lids, stay-cool ergonomic handles, induction-compatible bases, and heat-resistant silicone cooking utensils.',
     2499.00, 20, 'Home & Kitchen',
     '/images/granite_cookware_set.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     '20W USB-C Fast Charger with 6ft Cable',
     'High-speed 20W USB-C Power Delivery wall adapter plug bundled with an extra-long 6-foot heavy-duty Type-C charging cable for smartphones and tablets.',
     599.00, 50, 'Electronics',
     '/images/usbc_fast_charger.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Silicone Ice Cube Maker & Chilling Bucket',
     'Space-saving flexible silicone ice cube maker cylinder and drink chilling bucket with lid. Squeeze to release ice cubes instantly for beverages, smoothies, and cocktails.',
     399.00, 40, 'Home & Kitchen',
     '/images/silicone_ice_maker.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Double Buckle Cork Footbed Slide Sandals',
     'Classic unisex slide sandals crafted with twin adjustable buckled faux-suede straps, anatomical contoured cork footbed, and non-slip shock-absorbing EVA outsole.',
     1199.00, 25, 'Fashion & Style',
     '/images/cork_slide_sandals.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Mueller Pro-Series Multi-Blade Vegetable Chopper & Dicer',
     'Heavy-duty manual food chopper featuring sharp 420-grade stainless steel dicing and chopping blades, ergonomic push handle, large transparent catch container, and cleaning tool.',
     899.00, 35, 'Home & Kitchen',
     '/images/vegetable_chopper_dicer.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Glossy Black Leather Platform Penny Loafers',
     'Premium patent-look black leather slip-on penny loafers featuring a classic saddle cutout, cushioned leather insole, and chunky lugged platform sole for versatile modern styling.',
     2499.00, 20, 'Fashion & Style',
     '/images/black_leather_loafers.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Cuisinart 15-Piece Stainless Steel Knife Block Set (White)',
     'High-carbon stainless steel forged kitchen knife set featuring precision-tapered blades, ergonomic white triple-riveted handles, kitchen shears, and solid natural wooden storage block.',
     3299.00, 15, 'Home & Kitchen',
     '/images/knife_block_set_white.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'American Tall Matte Black Insulated Water Bottle',
     'Double-wall vacuum insulated stainless steel water bottle in sleek matte black finish. Features leak-proof flip cap, carrying loop, and 24-hour ice-cold temperature retention.',
     799.00, 35, 'Accessories',
     '/images/american_tall_water_bottle.jpg'),


    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Classic Oxford Textured Cotton Long Sleeve Shirt (Espresso)',
     'Premium micro-textured cotton long-sleeve casual shirt tailored with a button-down collar, front chest pocket, natural horn buttons, and breathable all-day comfort.',
     999.00, 40, 'Fashion & Style',
     '/images/oxford_cotton_shirt_brown.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Anker Magnetic Wireless MagSafe Power Bank (Sky Blue)',
     'Ultra-slim 5,000mAh magnetic portable charger featuring snap-and-go MagSafe wireless charging, bi-directional USB-C fast charging port, and soft-touch sky blue finish.',
     1499.00, 30, 'Electronics',
     '/images/magsafe_power_bank_blue.jpg'),


    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Computer Science: Object Oriented Programming in C++ (Grade 8)',
     'School curriculum computer science textbook covering fundamental object-oriented programming principles, syntax, logic building, functions, and structured problem solving in C++.',
     449.00, 30, 'Books',
     '/images/cpp_computer_science_grade8.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Matte Black Aerodynamic Full-Face Motorcycle Helmet',
     'Lightweight aerodynamic full-face riding helmet engineered with an impact-resistant ABS shell, drop-down tinted sun shield visor, dual-density EPS liner, and multi-point ventilation.',
     3899.00, 15, 'Accessories',
     '/images/matte_black_motorcycle_helmet.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Hollister Relaxed-Fit Elastic Waist Cargo Pants (Stone Khaki)',
     'Comfortable utility cargo trousers crafted from durable washed cotton twill with an elastic drawstring waistband, dual bellows side flap cargo pockets, and relaxed casual fit.',
     1699.00, 25, 'Fashion & Style',
     '/images/hollister_cargo_pants_khaki.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Washed Cotton Twill Button-Down Shirt (Sand Khaki)',
     'Casual relaxed-fit long sleeve shirt tailored from soft washed cotton twill, featuring a button-down collar, chest patch pocket, adjustable button cuffs, and earth-toned sand khaki shade.',
     1299.00, 35, 'Fashion & Style',
     '/images/classic_khaki_button_down_shirt.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'SuperVOOC 80W Fast Power Adapter & Red Type-C Cable Kit',
     'Ultra-high-speed SuperVOOC charging brick featuring intelligent power management and surge protection, bundled with signature heavy-duty red braided-style Type-A to Type-C flash charging cable.',
     1199.00, 45, 'Electronics',
     '/images/supervooc_fast_charger_kit.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Compact 60% RGB Mechanical Gaming Keyboard (Ultra-Portable)',
     'Space-saving 61-key ultra-compact mechanical keyboard featuring vibrant customizable multi-zone RGB backlighting, tactile switches, dual-shot ABS keycaps, and detachable Type-C connectivity.',
     2199.00, 25, 'Electronics',
     '/images/compact_60_mechanical_keyboard.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'BergHOFF Stainless Steel Balloon Whisk with Wooden Handle',
     'Chef-grade stainless steel wire balloon whisk equipped with an ergonomic natural oak wood handle and soft-mint comfort silicone collar, ideal for whipping eggs, batters, and sauces.',
     649.00, 30, 'Home & Kitchen',
     '/images/berghoff_wooden_balloon_whisk.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Handcrafted Solid Oak Countertop Egg Holder Tray (10-Hole Display)',
     'Artisan-crafted rustic wooden egg storage tray carved from premium solid oak hardwood with smooth beveled wells, designed to store and display farm-fresh countertop eggs in style.',
     799.00, 25, 'Home & Kitchen',
     '/images/wooden_countertop_egg_holder.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Luxury Croc-Embossed Leather Handbag (Ruby Red)',
     'Handcrafted structured top-handle handbag tailored in glossy crocodile-embossed genuine leather. Features signature turn-lock flap closure with silver padlock hardware, key clochette, and detachable shoulder strap.',
     4999.00, 15, 'Fashion & Style',
     '/images/red_croc_embossed_luxury_handbag.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     '4-Piece Natural Bamboo Cutting Board Set with Drip Groove',
     'Eco-friendly 100% natural organic bamboo cutting and chopping board set in 4 graduated culinary sizes. Equipped with built-in ergonomic cut-out handles, juice drip grooves, and knife-friendly surface.',
     1499.00, 30, 'Home & Kitchen',
     '/images/bamboo_cutting_board_set_4piece.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Modern Matte Forest Green Stoneware Dinnerware Set',
     'Artisan ceramic stoneware dining set finished in earthy matte forest green with warm unglazed rim detailing. Includes stackable pasta bowls, deep salad bowls, and dinner plates.',
     2799.00, 20, 'Home & Kitchen',
     '/images/forest_green_stoneware_dinnerware_set.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Faceted Geometric Ceramic Coffee Mugs (Set of 5 Gradient Tones)',
     'Contemporary stackable ceramic coffee and tea mugs sculpted with distinctive origami-inspired faceted geometric sides. Comes in a monochrome gradient palette from off-white to obsidian black.',
     1299.00, 35, 'Home & Kitchen',
     '/images/geometric_faceted_ceramic_mugs_set.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Vintage Knit Open-Collar Polo Shirt (Espresso & Cream)',
     'Retro-inspired fine knit cotton polo shirt in rich espresso brown, accented with contrast cream open-notch collar, chest welt pocket trim, and ribbed tipping cuffs.',
     1499.00, 30, 'Fashion & Style',
     '/images/chocolate_brown_retro_knit_polo.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Minimalist Ceramic Round Dinner Plates with Glazed Rim (Set of 6)',
     'Modern stackable stoneware dining plates featuring an organic off-white matte glaze, raised anti-spill rim with hand-painted earthy rim accent, and microwave/dishwasher-safe ceramic construction.',
     1699.00, 30, 'Home & Kitchen',
     '/images/ceramic_round_dinner_plates_set.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Logitech G502 HERO High-Performance Gaming Mouse',
     'Iconic ergonomic gaming mouse featuring HERO 25K optical sensor with 25,600 DPI precision, 11 programmable buttons, customizable weight tuning system, and LIGHTSYNC RGB illumination.',
     3999.00, 25, 'Electronics',
     '/images/logitech_g502_hero_gaming_mouse.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Apple AirPods Pro (2nd Gen) with MagSafe USB-C Case',
     'Flagship true wireless earbuds featuring H2 chip audio, 2x stronger Active Noise Cancellation, Adaptive Audio, Personalized Spatial Audio with dynamic head tracking, and MagSafe charging case.',
     18990.00, 15, 'Electronics',
     '/images/apple_airpods_pro_wireless_earbuds.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Designer Trio Messenger Crossbody Bag (Monogram Eclipse)',
     'Modular 3-in-1 luxury crossbody messenger bag crafted from durable Monogram Eclipse coated canvas with black cowhide leather trim, removable front zipped pouch, and detachable coin purse.',
     5499.00, 15, 'Accessories',
     '/images/monogram_eclipse_trio_messenger_bag.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Architectural Square Polarized Sunglasses (Titanium Grey)',
     'Modern square silhouette sunglasses crafted with a lightweight titanium bridge, double-rimmed dark slate frame, anti-glare polarized gradient UV400 lenses, and adjustable silicone nose pads.',
     1899.00, 30, 'Accessories',
     '/images/titanium_square_polarized_sunglasses.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Pebbled Cognac Leather Men''s Bifold Wallet (Contrast Stitch)',
     'Handcrafted men''s bifold wallet crafted from supple pebbled full-grain cognac brown leather. Features durable contrast white perimeter stitching, silver-tone metal logo accent bar, multiple card slots, and dual currency compartments.',
     799.00, 35, 'Accessories',
     '/images/cognac_pebbled_leather_wallet.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Python From Zero: A Complete Programming Guide',
     'Comprehensive beginner-to-advanced guide to Python programming by Jenson A. Larson. Covers core syntax, data structures, object-oriented concepts, modular design, and real-world coding projects.',
     599.00, 40, 'Books',
     '/images/python_from_zero_book.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Software Engineering and Algorithms (Springer LNNS 230)',
     'Academic proceedings of the 10th Computer Science On-line Conference edited by Radek Silhavy. Published by Springer, covering cutting-edge research in software architecture, algorithm design, and computational systems.',
     899.00, 25, 'Books',
     '/images/software_engineering_and_algorithms_book.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Pagani Design All-Black Chronograph Stainless Steel Watch',
     'Sleek stealth luxury timepiece engineered in PVD-coated matte black stainless steel. Features a high-precision Japanese quartz chronograph movement, tachymeter bezel, scratch-resistant sapphire crystal, and 100m water resistance.',
     4499.00, 20, 'Accessories',
     '/images/pagani_design_black_chronograph_watch.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Rongke Polo Automatic Ratchet Genuine Leather Belt',
     'Premium men''s automatic slide ratchet dress belt crafted from genuine black full-grain leather. Features a micro-adjustable sliding track, modern matte buckle with tri-color accent striping, and no-hole custom fit.',
     699.00, 35, 'Accessories',
     '/images/rongke_polo_automatic_ratchet_leather_belt.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Nike Free Metcon Cross-Training Workout Sneakers',
     'High-performance athletic cross-training shoes combining Nike Free forefoot flexibility with Metcon heel stability. Features breathable engineered mesh upper, plush foam cushioning, and deep tread outsole grip.',
     5999.00, 20, 'Fashion & Style',
     '/images/nike_free_metcon_training_sneakers.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Acacia Natural Hardwood Cooking Utensil Set (10-Piece)',
     'Handcrafted 10-piece culinary cooking utensil set carved from 100% natural organic acacia wood. Includes wok turners, slotted spatulas, soup ladles, serving spoons, matching countertop storage cylinder crock, and ergonomic spoon rest.',
     1799.00, 30, 'Home & Kitchen',
     '/images/acacia_wood_kitchen_utensils_set.jpg'),

    ((SELECT id FROM users WHERE email = 'admin@praveenmart.com'),
     'Pro Multi-Pocket Travel Laptop Backpack (Water-Resistant)',
     'Ergonomic multi-compartment travel tech backpack crafted from durable water-repellent oxford fabric. Features padded 15.6" laptop compartment, vibrant red pull cords, breathable air-mesh shoulder straps, and quick-access organizer pockets.',
     1699.00, 35, 'Accessories',
     '/images/pro_travel_laptop_backpack_black.jpg');
