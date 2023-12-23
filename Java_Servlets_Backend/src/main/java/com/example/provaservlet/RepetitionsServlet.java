package com.example.provaservlet;

import DAO.DAO;
import DAO.Ripetizione;
import com.google.gson.Gson;
import org.json.simple.JSONObject;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Objects;

@WebServlet(name = "repetitions", value = "/repetitions")
public class RepetitionsServlet extends HttpServlet {
    private String message;
    private DAO DAO = null;

    public void init(ServletConfig config) {
        ServletContext ctx = config.getServletContext();
        DAO = (DAO) ctx.getAttribute("DAO");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        //cors policy -- permette di effettuare chiamate alla servlet da un'altra porta
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");

        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession();

        if (s.isNew()) System.out.println("Sessione nuova");
        else System.out.println("Session id: " + s.getId());
        System.out.println("attributo username della sessione: " + s.getAttribute("username"));
        JSONObject json = new JSONObject();
        if(Objects.equals(request.getParameter("action"), "admin")){
            System.out.println("--------------------------------------------- repetitions admin");
            if (s.getAttribute("username") != null) {
                //Prelevo i dati dal db
                System.out.println("utente: " + s.getAttribute("username"));
                ArrayList<Ripetizione> Ripetizioni = Ripetizione.readAllRepetitions(DAO);
                json.put("repetitions", new Gson().toJson(Ripetizioni));
                json.put("status", "OK");
                System.out.println(json);
                out.println(json);
            } else {
                //accesso negato
                json.put("status", "AUTHENTICATION_REQUIRED");
                System.out.println(json);
                out.print(json);
            }
        }else{
            if (request.getParameter("teacherId") != null) {
                System.out.println("--------------------------------------------- repetitions teacher");

                int teacherId = -1;
                try {
                    teacherId = Integer.parseInt(request.getParameter("teacherId"));
                    //Prelevo i dati dal db
                    ArrayList<Ripetizione> RipetizioniDoc = Ripetizione.readTeacherRepetitons(DAO, teacherId);
                    json.put("repetitions", new Gson().toJson(RipetizioniDoc));
                    json.put("status", "OK");
                    System.out.println(json);
                    out.println(json);

                } catch (Exception e) {
                    System.out.println(e);
                    json.put("status", "INVALID_TEACHER_ID");
                    System.out.println(json);
                    out.print(json);
                }
            } else {
                System.out.println("--------------------------------------------- repetitions user");
                if (s.getAttribute("username") != null) {
                    String idUtente = request.getParameter("userId");
                    //Prelevo i dati dal db
                    ArrayList<Ripetizione> RipetizioniDoc = Ripetizione.readUserRepetitons(DAO, idUtente);
                    json.put("repetitions", new Gson().toJson(RipetizioniDoc));
                    json.put("status", "OK");
                    System.out.println(json);
                    out.println(json);
                } else {
                    //accesso negato
                    json.put("status", "AUTHENTICATION_REQUIRED");
                    System.out.println(json);
                    out.print(json);
                }

            }
        }
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");

        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession();
        JSONObject json = new JSONObject();

        String action = request.getParameter("action");
        if (s.isNew()) System.out.println("Sessione nuova");
        else System.out.println("Session id: " + s.getId());
        System.out.println("attributo username della sessione: " + s.getAttribute("username")+ " -------- con action: " + action);



        if (s.getAttribute("username") != null) {
            String idUtente;
            int idCorso;
            int idDisponibilita;
            int idRipetizione = -1;


            try {
                    boolean succed = false;
                    if(Objects.equals(action, "insert")) {
                        System.out.println("--------------------------------------------- insert repetition");
                        //controllo gli input per la insert
                        idUtente = request.getParameter("idUtente");
                        idCorso = Integer.parseInt(request.getParameter("idCorso"));
                        idDisponibilita = Integer.parseInt(request.getParameter("idDisponibilita"));
                        if (idUtente == null) {
                            json.put("status", "INVALID_PARAMETERS");
                            System.out.println(json);
                            out.print(json);
                        }
                        succed = Ripetizione.insertRepetition(DAO, idCorso, idUtente, idDisponibilita);
                    } else
                    {
                        idRipetizione = Integer.parseInt(request.getParameter("idRipetizione"));
                        if (idRipetizione == -1) {
                            json.put("status", "INVALID_PARAMETERS");
                            System.out.println(json);
                            out.print(json);
                        }else if (Objects.equals(action, "confirm")) {
                            System.out.println("--------------------------------------------- confirm repetition");
                            succed = Ripetizione.modifyRepetition(DAO, idRipetizione, true);
                        } else if (Objects.equals(action, "delete")) {
                            System.out.println("--------------------------------------------- delete repetition");
                            succed = Ripetizione.modifyRepetition(DAO, idRipetizione, false);
                        }
                    }
                    if (succed)
                        json.put("status", "OK");
                    else
                        json.put("status", "FAILED");
                    out.println(json);
                    System.out.println(json);
            } catch (Exception e) {
                json.put("status", "INVALID_PARAMETERS");
                System.out.println(json);
                out.print(json);
            }
        } else {
            //accesso negato
            json.put("status", "AUTHENTICATION_REQUIRED");
            System.out.println(json);
            out.print(json);
        }
    }


}
