package DAO;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

//import static DAO.DAO.*;

public class Docente {
    private int idDocente;
    private String email;

    private String nome;
    private String cognome;
    private String sesso;
    private int eta;
    private String formazione;
    private int prezzoH;
    private String imageUrl;
    private String imageUrlUniversity;

    public Docente(int idDocente, String email, String nome, String cognome, String sesso, int eta, String formazione, int prezzoH, String imageUrl, String imageUrlUniversity) {
        this.email = email;
        this.nome = nome;
        this.cognome = cognome;
        this.idDocente = idDocente;
        this.sesso = sesso;
        this.eta = eta;
        this.formazione = formazione;
        this.prezzoH = prezzoH;
        this.imageUrl = imageUrl;
        this.imageUrlUniversity = imageUrlUniversity;
    }

    public int getIdDocente() {
        return idDocente;
    }
    public String getEmail() {
        return email;
    }

    public String getNome() {
        return nome;
    }

    public String getCognome() {
        return cognome;
    }
    public int getPrezzoH() {
        return prezzoH;
    }
    public int getEta() {
        return eta;
    }
    public String getSesso() {
        return sesso;
    }
    public String getFormazione() {
        return formazione;
    }
    public String getgetImageUrlUniversity() {
        return imageUrlUniversity;
    }
    public String getImageUrl() {return imageUrl;}



    public static void printDocente(DAO DAO){
        try {
            DAO.registerDriver();
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM docente");
            while (rs.next()) {
                //Docente p = new Docente(rs.getString("NOME"),rs.getString("COGNOME"), rs.getString("MATRICOLA"));
                //out.add(p);
                System.out.println("NOME: " + rs.getString("Nome") + " COGNOME: " + rs.getString("Cognome"));
            }
        }catch (SQLException e){
            System.out.println(e.getMessage());
        }finally {
            DAO.closeConnection();
        }
    }

    public static ArrayList<Docente> readAll(DAO DAO) throws DAOException {
        ArrayList<Docente> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM DOCENTE WHERE `attivo` = 1");
            while (rs.next()) {
                Docente d = new Docente(
                        rs.getInt("IDDocente"), rs.getString("email"),
                        rs.getString("nome"), rs.getString("cognome"),
                        rs.getString("sesso"), rs.getInt("eta"),
                        rs.getString("formazione"), rs.getInt("prezzoH"),
                        rs.getString("imageUrl"), rs.getString("imageUrlUniversity"));
                out.add(d);
            }
        } catch (SQLException e) {
            throw new DAOException("Docente readAll: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }

    public static ArrayList<Docente> readCourseTeachers(DAO DAO, int courseId) throws DAOException {
        ArrayList<Docente> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM `docente`, `corsodocente` " +
                    "WHERE docente.idDocente = corsodocente.idDocente AND corsodocente.attivo = 1 " +
                    "AND corsodocente.idCorso = "+courseId);
            while (rs.next()) {
                Docente d = new Docente(
                        rs.getInt("IDDocente"), rs.getString("email"),
                        rs.getString("nome"), rs.getString("cognome"),
                        rs.getString("sesso"), rs.getInt("eta"),
                        rs.getString("formazione"), rs.getInt("prezzoH"),
                        rs.getString("imageUrl"), rs.getString("imageUrlUniversity"));
                out.add(d);
            }
        } catch (SQLException e) {
            throw new DAOException("Docente readCourseTeachers: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }

    public static boolean createDocente(DAO DAO,String email, String Nome, String Cognome, String sesso, String
                                        formazione, int eta, int prezzoH, String imageUrl){
        try {
            DAO.registerDriver();
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            st.executeUpdate("INSERT INTO `docente`(`email`,`nome`, `cognome`, `sesso`, `eta`, `formazione`, " +
                    "`prezzoH`, `imageUrl`) VALUES ('"+email+"','"+Nome+"','"+Cognome+"','"+sesso+"','"+eta+"'," +
                    "'"+formazione+"','"+prezzoH+"','"+imageUrl+"')");
        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }

    public static boolean deleteTeacher(DAO DAO,int idDocente){
        try {
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM `docente` WHERE `idDocente` = "+idDocente);

            if(!rs.next()){
                return false;
            }
            st.executeUpdate("UPDATE `docente` SET `attivo` = 0 " +
                    "WHERE `idDocente` = " + idDocente);


        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }

    @Override
    public String toString() {
        return nome + " " + cognome + " " + idDocente;
    }
}
