package DAO;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
public class Ripetizione {
    public int getIdRipetizione() {
        return idRipetizione;
    }

    public String getIdUtente() {
        return idUtente;
    }

    public int getIdCorso() {
        return idCorso;
    }

    public int getIdDisponibilita() {
        return idDisponibilita;
    }

    public int getIdDocente() {
        return idDocente;
    }

    private int idRipetizione;
    private String idUtente;
    private int idCorso;
    private int idDisponibilita;
    private int idDocente;
    private String nomeDocente;
    private String cognomeDocente;
    private String imageUrlDocente;
    private String nomeCorso;
    private String dataInizio;
    private String dataFine;
    private int stato;
    private String username;
    public Ripetizione(int idRipetizione, String idUtente, int idCorso, int idDisponibilita, int idDocente) {
        this.idRipetizione = idRipetizione;
        this.idUtente = idUtente;
        this.idCorso = idCorso;
        this.idDisponibilita = idDisponibilita;
        this.idDocente = idDocente;
    }
    public Ripetizione(int idRipetizione, int idDisponibilita, String nomeDocente, String cognomeDocente,String
            imageUrl, String nomeCorso, String dataInizio, String dataFine, int stato, String username,
            int idDocente, int idCorso) {
        this.idRipetizione = idRipetizione;
        this.idDisponibilita = idDisponibilita;
        this.nomeDocente = nomeDocente;
        this.cognomeDocente = cognomeDocente;
        this.imageUrlDocente = imageUrl;
        this.nomeCorso = nomeCorso;
        this.dataInizio = dataInizio;
        this.dataFine = dataFine;
        this.stato  = stato;
        this.username = username;
        this.idCorso = idCorso;
        this.idDocente = idDocente;
    }
    public static boolean insertRepetition(DAO DAO,int idCorso, String idUtente, int idDisponibilita){
        try {
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM ripetizione WHERE stato != 2 AND " +
                    "idDisponibilita = "+idDisponibilita);

            if(rs.next()){
                System.out.println(rs.getInt("idRipetizione"));
                return false;
            }
            System.out.println(idCorso + " "+ idUtente + " " + idDisponibilita);
            st.executeUpdate("INSERT INTO `ripetizione`(`idCorso`, `idUtente`, `idDisponibilita`) " +
                    "VALUES ("+idCorso+",'"+idUtente+"',"+idDisponibilita+")");
        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }

    public static boolean modifyRepetition(DAO DAO,int idRipetizione,boolean confirm){
        try {
            Connection conn = DAO.openConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM `ripetizione` WHERE `idRipetizione` = "+idRipetizione);

            if(!rs.next()){
                return false;
            }
            if(confirm)
            {
                st.executeUpdate("UPDATE `ripetizione` SET `stato` = 1 " +
                        "WHERE `idRipetizione` = " + idRipetizione);
            }else {
                st.executeUpdate("UPDATE `ripetizione` SET `stato` = 2 " +
                        "WHERE `idRipetizione` = " + idRipetizione);
            }

        }catch (SQLException e){
            System.out.println(e.getMessage());
            return false;
        }finally {
            DAO.closeConnection();
        }
        return true;
    }
    /*Ripetizioni prenotate (attive o confermata, NON cancellate)*/
    public static ArrayList<Ripetizione> readTeacherRepetitons(DAO DAO, int teacherId) throws DAOException {
        ArrayList<Ripetizione> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            System.out.println("teacherId: "+teacherId);
            ResultSet rs = st.executeQuery("SELECT * FROM `ripetizione`,`disponibilita`" +
                    " WHERE ripetizione.idDisponibilita = disponibilita.idDisponibilita" +
                    " AND ripetizione.stato != 2 AND disponibilita.idDocente = "+teacherId);
            while (rs.next()) {
                Ripetizione r = new Ripetizione(rs.getInt(
                        "idRipetizione"), rs.getString("idUtente"),
                        rs.getInt("idCorso"),rs.getInt("idDisponibilita"),
                        rs.getInt("idDocente"));
                out.add(r);
            }
        } catch (SQLException e) {
            throw new DAOException("Ripetizione readTeacherRepetitons: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }


    public static ArrayList<Ripetizione> readUserRepetitons(DAO DAO, String idUtente) throws DAOException {
        ArrayList<Ripetizione> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            System.out.println("idUtente: "+idUtente);
            ResultSet rs = st.executeQuery("SELECT ripetizione.idRipetizione, disponibilita.idDisponibilita, " +
                    "docente.nome AS nomeDocente, docente.cognome AS cognomeDocente, docente.imageUrl AS imgDocente, " +
                    "corso.nome AS nomeCorso, dataInizio, dataFine, stato, username, docente.idDocente, corso.id AS idCorso" +
                    " FROM `ripetizione`,`disponibilita`,`docente`,`corso`, `utente`" +
                    " WHERE ripetizione.idDisponibilita = disponibilita.idDisponibilita " +
                    "AND disponibilita.idDocente = docente.idDocente AND corso.id = ripetizione.idCorso" +
                    " AND username = ripetizione.idUtente AND ripetizione.idUtente ='" +idUtente+"'");
            while (rs.next()) {
                Ripetizione r = new Ripetizione(rs.getInt(
                        "idRipetizione"), rs.getInt("idDisponibilita"),
                        rs.getString("nomeDocente"),rs.getString("cognomeDocente"),
                        rs.getString("imgDocente"),rs.getString("nomeCorso"),
                        rs.getString("dataInizio"),rs.getString("dataFine"),
                        rs.getInt("stato"),rs.getString("username"),
                        rs.getInt("idDocente"),rs.getInt("idCorso"));
                out.add(r);
            }
        } catch (SQLException e) {
            System.out.println(e);
            throw new DAOException("Ripetizione readUserRepetitons: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }

    public static ArrayList<Ripetizione> readAllRepetitions(DAO DAO) throws DAOException {
        ArrayList<Ripetizione> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT ripetizione.idRipetizione, disponibilita.idDisponibilita, " +
                    "docente.nome AS nomeDocente, docente.cognome AS cognomeDocente, docente.imageUrl AS imgDocente," +
                    " corso.nome AS nomeCorso, dataInizio, dataFine, stato, username, docente.idDocente, corso.id AS idCorso" +
                    " FROM `ripetizione`,`disponibilita`,`docente`,`corso`,`utente` " +
                    "WHERE ripetizione.idDisponibilita = disponibilita.idDisponibilita AND " +
                    "disponibilita.idDocente = docente.idDocente AND corso.id = ripetizione.idCorso AND username = idUtente");
            while (rs.next()) {
                Ripetizione r = new Ripetizione(rs.getInt(
                        "idRipetizione"), rs.getInt("idDisponibilita"),
                        rs.getString("nomeDocente"),rs.getString("cognomeDocente"),
                        rs.getString("imgDocente"),rs.getString("nomeCorso"),
                        rs.getString("dataInizio"),rs.getString("dataFine"),
                        rs.getInt("stato"),rs.getString("username"),
                        rs.getInt("idDocente"),rs.getInt("idCorso"));
                out.add(r);
            }
        } catch (SQLException e) {
            throw new DAOException("Ripetizione readUserRepetitons: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }

}
