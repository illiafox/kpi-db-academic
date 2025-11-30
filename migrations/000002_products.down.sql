DROP INDEX IF EXISTS product_fts_gin_idx;
DROP INDEX IF EXISTS product_manufacturer_idx;
DROP INDEX IF EXISTS product_category_idx;

DROP TABLE IF EXISTS products;

DROP TABLE IF EXISTS manufacturers;
DROP TABLE IF EXISTS product_categories;
