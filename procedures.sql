CREATE OR REPLACE PROCEDURE UserCreate(
    username VARCHAR,
    hashed_password VARCHAR,
    email VARCHAR
)
LANGUAGE 'plpgsql'
AS $$
BEGIN
    INSERT INTO users(username, hashed_password, email) VALUES (username, hashed_password, email);
COMMIT;
END;
$$;


CALL UserCreate('Nickolas', '111111111', 'the@out.com');

SELECT * FROM users;


CREATE OR REPLACE PROCEDURE CategoryCreate(
    category_name VARCHAR
)
LANGUAGE "plpgsql"
AS $$
BEGIN
    INSERT INTO categories(category_name) VALUES (category_name);
COMMIT;
END;
$$;

CALL CategoryCreate('Food');
SELECT * from categories;
