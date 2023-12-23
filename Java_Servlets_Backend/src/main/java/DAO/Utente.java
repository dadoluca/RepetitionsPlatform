package DAO;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class Utente {
    private String username;
    private String password;
    private int ruolo;



    public Utente(String username, String password, int ruolo) {
        this.username = username;
        this.password = password;
        this.ruolo = ruolo;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public int getRuolo() {
        return ruolo;
    }

    public static boolean createUtente(DAO DAO,String Username, String Password){
        try {
            //DAO.registerDriver();
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            st.executeUpdate("INSERT INTO `utente`(`Username`, `Password`) VALUES ('"+Username+"','"+Password+"')");
        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }

    public static Utente searchUser(DAO DAO,String Username, String Password){
        try {
            //DAO.registerDriver();
            Utente newUser;
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM utente WHERE Username = '" +Username+"' AND " +
                    "Password = '" +Password+"'");
            if(rs.next()){
                String nome = rs.getString("username");
                String password = rs.getString("password");
                int ruolo = rs.getInt("ruolo");
                newUser = new Utente(nome,password,ruolo);
                return newUser;
            }
        }catch (SQLException e){
            System.out.println(e.getMessage());
            return null;
        }finally {
            DAO.closeConnection();
        }
        return null;
    }

    @Override
    public String toString() {
        return username + " " + password ;
    }
}
