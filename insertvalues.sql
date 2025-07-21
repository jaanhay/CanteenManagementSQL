use canteen;
INSERT INTO Ingredients (Name, Category, UnitOfMeasure, CurrentStock, ReorderLevel)
VALUES
    ('Flour', 'Baking', 'kg', 50.00, 10.00),
    ('Sugar', 'Baking', 'kg', 30.50, 5.00),
    ('Eggs', 'Dairy', 'unit', 100.00, 20.00),
    ('Milk', 'Dairy', 'L', 20.00, 5.00),
    ('Chocolate Chips', 'Baking', 'g', 200.00, 50.00);
INSERT INTO recipes (name, serving_size, instructions)
VALUES
    ('Chocolate Chip Cookies', 12, '1. Preheat the oven to 350°F. ...'),
    ('Pancakes', 4, '1. In a bowl, mix flour, sugar, and baking powder. ...'),
    ('Scrambled Eggs', 2, '1. Crack the eggs into a bowl. ...');
    
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity)
VALUES
    (1, 1, 300.00),
    (1, 2, 150.00),
    (1, 3, 2.00),
    (1, 4, 100.00),
    (1, 5, 150.00),
    (2, 1, 200.00),
    (2, 2, 100.00),
    (2, 3, 3.00),
    (3, 3, 4.00);
    
insert into Item values(1, 2, 'Pancakes', 1);
