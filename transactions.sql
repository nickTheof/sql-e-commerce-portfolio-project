
-- Procedure to delete a user and their related orders and order items with error handling

DO $$
DECLARE
    user_exists BOOLEAN;
BEGIN
    -- Check if the user exists
    SELECT EXISTS (SELECT 1 FROM users WHERE user_id = 6) INTO user_exists;
    IF NOT user_exists THEN
        RAISE EXCEPTION 'User with user_id 6 does not exist.';
    END IF;

    -- Delete order items related to the user's orders
    DELETE FROM order_items
    WHERE order_id IN (SELECT order_id FROM orders WHERE user_id = 6);

    -- Delete orders related to the user
    DELETE FROM orders
    WHERE user_id = 6;

    -- Delete the user
    DELETE FROM users
    WHERE user_id = 6;

EXCEPTION
    WHEN OTHERS THEN
        -- Rollback transaction in case of error
        RAISE;
END;
$$;