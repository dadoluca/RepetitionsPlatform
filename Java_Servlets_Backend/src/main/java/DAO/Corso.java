package DAO;

import javax.print.Doc;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.*;
import java.util.ArrayList;

//import static DAO.DAO.*;

public class Corso {
    private int id;
    private String nome;
    private String imageUrl;

    public Corso(int id, String nome, String imageUrl) {
        this.id = id;
        this.nome = nome;
        this.imageUrl = imageUrl;
    }

    public int getIdD() {
        return id;
    }

    public String getNome() {
        return nome;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public static void printCourses(DAO DAO){
        try {
            DAO.registerDriver();
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM corso");
            while (rs.next()) {
                //Docente p = new Docente(rs.getString("NOME"),rs.getString("COGNOME"), rs.getString("MATRICOLA"));
                //out.add(p);
                System.out.println("id: " + rs.getString("Nome") + " nome: " + rs.getString("Cognome"));
            }
        }catch (SQLException e){
            System.out.println(e.getMessage());
        }finally {
            DAO.closeConnection();
        }
    }

    public static ArrayList<Corso> readAll(DAO DAO) throws DAOException {
        ArrayList<Corso> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM corso WHERE `attivo` = " + 1);
            while (rs.next()) {
                Corso c = new Corso(rs.getInt("id"), rs.getString("nome"), rs.getString("imageUrl"));
                out.add(c);
            }
        } catch (SQLException e) {
            throw new DAOException("Corso readAll: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }

    public static ArrayList<Corso> readTeacherCourse(DAO DAO, int idDocente) throws DAOException {
        ArrayList<Corso> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM corso, corsodocente " +
                    "WHERE `id` = idCorso AND corsodocente.attivo = " + 1 +" AND corso.attivo = " + 1 + " AND `idDocente` = '" + idDocente + "'");
            while (rs.next()) {
                Corso c = new Corso(rs.getInt("id"), rs.getString("nome"), rs.getString("imageUrl"));
                out.add(c);
            }
        } catch (SQLException e) {
            throw new DAOException("Corso readAll: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }

    public static boolean createCorso(DAO DAO,String nomeCorso){
        try {
            DAO.registerDriver();
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM `corso` WHERE `nome` = '"+nomeCorso + "'");
            if(!rs.next()){
                st.executeUpdate("INSERT INTO `corso`(`nome`) VALUES ('"+nomeCorso+"')");
            }else{
                if(rs.getInt("attivo") == 0)
                    st.executeUpdate("UPDATE `corso` SET `attivo` = 1 " +
                        "WHERE `id` = " + rs.getInt("id"));
                else
                    return false;
            }
        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }

    public static boolean deleteCorso(DAO DAO, int idCorso) throws DAOException {
        try {
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM `corso` WHERE `id` = "+idCorso);

            if(!rs.next()){
                return false;
            }
            st.executeUpdate("UPDATE `corso` SET `attivo` = 0 " +
                    "WHERE `id` = " + idCorso);
        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }

    public static boolean deleteCourseTeacher(DAO DAO, int idCorso, int idDocente) throws DAOException {
        try {
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM `corsodocente` WHERE `idDocente` = "+idDocente +
                    " AND `idCorso` = " + idCorso);

            if(!rs.next()){
                return false;
            }
            st.executeUpdate("UPDATE `corsodocente` SET `attivo` = 0 " +
                    "WHERE `idDocente` = " + idDocente + " AND `idCorso` = " + idCorso);


        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }

    public static boolean createCourseTeacher(DAO DAO, int idCorso, int idDocente) throws DAOException {
        try {
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();

            ResultSet rs = st.executeQuery("SELECT * FROM `corsodocente` WHERE `idDocente` = "+idDocente +
                    " AND `idCorso` = " + idCorso);

            if(!rs.next()){
                st.executeUpdate("INSERT INTO `corsodocente`(`idCorso`,`idDocente`) VALUES ('"+idCorso+"','"+idDocente+"')");
            }else{
                st.executeUpdate("UPDATE `corsodocente` SET `attivo` = 1 " +
                        "WHERE `idDocente` = " + idDocente + " AND `idCorso` = " + idCorso);
            }


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
        return id + " " + nome + " " + imageUrl;
    }
}
