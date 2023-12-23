package DAO;

import java.sql.*;
import java.util.ArrayList;

public class DAO {

    private final String url1;// = "jdbc:mysql://localhost:3306/ripetizioni";
    private final String user;// = "root";
    private final String password;// = "";

    private Connection conn;

    public DAO(String url1, String user, String password){
        this.user = user;
        this.password = password;
        this.url1 = url1;
        registerDriver();
    }

    public static void registerDriver() {
        try {
            DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            System.out.println("Driver correttamente registrato");
        } catch (SQLException e) {
            System.out.println("Errore: " + e.getMessage());
        }
    }

    public Connection openConnection() throws DAOException{
        try {
            conn = DriverManager.getConnection(url1, user, password);
            if (conn != null) {
                System.out.println("Ho aperto la connessione al DB");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
        return conn;

    }

    public void closeConnection(){
        try {
            conn = DriverManager.getConnection(url1, user, password);
            if (conn != null) {
                conn.close();
                System.out.println("Ho chiuso la connessione al DB");
            }
        } catch (SQLException e) {
            System.out.println(e.getMessage());
        }
    }
}
