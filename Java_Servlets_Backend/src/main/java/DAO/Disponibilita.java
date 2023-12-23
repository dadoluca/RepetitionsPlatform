package DAO;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

//import static DAO.DAO.*;

public class Disponibilita {
    private int idDisponibilita;
    private String dataInizio;
    private String dataFine;
    private int idDocente;

    public int getIdDisponibilita() {
        return idDisponibilita;
    }

    public String getDataInizio() {
        return dataInizio;
    }

    public String getDataFine() {
        return dataFine;
    }

    public int getIdDocente() {
        return idDocente;
    }

    public Disponibilita(int idDisponibilita, String dataInizio, String dataFine, int idDocente) {
        this.idDisponibilita = idDisponibilita;
        this.dataInizio = dataInizio;
        this.dataFine = dataFine;
        this.idDocente = idDocente;
    }
    public static ArrayList<Disponibilita> readTeacherAvailability(DAO DAO, int teacherId) throws DAOException {
        ArrayList<Disponibilita> out = new ArrayList<>();
        try (Connection conn = DAO.openConnection()) {
            Statement st = conn.createStatement();
            System.out.println("teacherId: "+teacherId);
            ResultSet rs = st.executeQuery("SELECT * FROM `docente`, `disponibilita` " +
                    "WHERE docente.idDocente = disponibilita.idDocente " +
                    "AND docente.idDocente = "+teacherId);
            while (rs.next()) {
                Disponibilita d = new Disponibilita(rs.getInt(
                        "IdDisponibilita"), rs.getString("dataInizio"),
                        rs.getString("dataFine"),rs.getInt("IDDocente"));
                out.add(d);
            }
        } catch (SQLException e) {
            throw new DAOException("Disponibilita readTeacherAvailability: " + e);
        }
        finally {
            DAO.closeConnection();
        }
        return out;
    }

    @Override
    public String toString() {
        return idDisponibilita + " " + dataInizio + " " + dataFine + " "+idDocente;
    }
}
