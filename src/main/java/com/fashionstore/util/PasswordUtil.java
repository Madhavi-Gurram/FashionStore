
package com.fashionstore.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {

    // Number of salt rounds — higher = more secure but slower
    private static final int SALT_ROUNDS = 12;

    // =============================================
    // HASH PASSWORD
    // =============================================
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt(SALT_ROUNDS));
    }

    // =============================================
    // VERIFY PASSWORD
    // =============================================
    public static boolean verifyPassword(String plainPassword, String hashedPassword) {
        try {
            return BCrypt.checkpw(plainPassword, hashedPassword);
        } catch (Exception e) {
            return false;
        }
    }
}