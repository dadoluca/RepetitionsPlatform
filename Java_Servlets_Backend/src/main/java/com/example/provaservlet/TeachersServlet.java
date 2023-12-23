package com.example.provaservlet;

import DAO.Docente;
import DAO.DAO;
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

@WebServlet(name = "teachers", value = "/teachers")
public class TeachersServlet extends HttpServlet {
    private String message;
    private DAO DAO = null;

    public void init(ServletConfig config) {
        ServletContext ctx = config.getServletContext();
        DAO = (DAO) ctx.getAttribute("DAO");
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        //cors policy -- permette di effettuare chiamate alla servlet da un'altra porta
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");
        response.setContentType("application/json");


        int courseId = -1;
        try{
            courseId = Integer.parseInt(request.getParameter("courseId"));
        } catch (Exception e) {
        }

        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession();

        System.out.println("--------------------------------------------- teachers");
        if(s.isNew())System.out.println("Sessione nuova");
        else System.out.println("Session id: "+s.getId());
        System.out.println("attributo username della sessione: "+s.getAttribute("username") );


        JSONObject obj = new JSONObject();
        Gson gson = new Gson();

        ArrayList<Docente> docenti;
        String res;

        // if (s.getAttribute("utente") != null) {
        if(courseId!=-1){
            System.out.println("courseId: "+courseId);
            docenti = Docente.readCourseTeachers(DAO,courseId);
            res = gson.toJson(docenti);
        }
        else{
            docenti = Docente.readAll(DAO);
            res = gson.toJson(docenti);
        }
        System.out.println(res);
        out.println(res);

        //}else{
            //accesso negato
        //}

        //        processRequest(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.addHeader("Access-Control-Allow-Origin", "*");
        response.setContentType("application/json");

        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession();
        JSONObject json = new JSONObject();
        String action = request.getParameter("action");
        System.out.println("Action: " + action);

        if (s.isNew()) System.out.println("Sessione nuova");
        else System.out.println("Session id: " + s.getId());
        System.out.println("attributo username della sessione: " + s.getAttribute("username"));

        if (s.getAttribute("username") != null) {
            boolean succed = false;
            if(Objects.equals(action, "insert"))
            {
                String email;
                String nome;
                String cognome;
                String sesso;
                String formazione;
                String imageUrl;
                int eta = 0;
                int prezzoH = 0;

                try {
                    System.out.println("--------------------------------------------- insert teacher");
                    //controllo gli input per la insert
                    email = request.getParameter("email");
                    nome = request.getParameter("nome");
                    cognome = request.getParameter("cognome");
                    sesso = request.getParameter("sesso");
                    formazione = request.getParameter("formazione");
                    eta = Integer.parseInt(request.getParameter("eta"));
                    prezzoH = Integer.parseInt(request.getParameter("prezzoH"));
                    imageUrl = request.getParameter("imageUrl");
                    if (email == null || nome == null || cognome == null || sesso == null || formazione == null || eta == 0
                            || prezzoH == 0) {
                        json.put("status", "INVALID_PARAMETERS");
                        System.out.println(json);
                        out.print(json);
                    } else {
                        succed = Docente.createDocente(DAO, email, nome, cognome, sesso, formazione, eta, prezzoH, imageUrl);
                        if (succed)
                            json.put("status", "OK");
                        else
                            json.put("status", "FAILED");
                        out.println(json);
                        System.out.println(json);
                    }

                } catch (Exception e) {
                    json.put("status", "INVALID_PARAMETERS");
                    System.out.println(json);
                    out.print(json);
                }
            }
            else if(Objects.equals(action, "delete")){
                int idDocente = -1;
                try {
                    System.out.println("--------------------------------------------- delete teacher");
                    //controllo gli input per la delete
                    idDocente = Integer.parseInt(request.getParameter("idDocente"));

                    if (idDocente == -1) {
                        json.put("status", "INVALID_PARAMETERS");
                        System.out.println(json);
                        out.print(json);
                    } else {
                        succed = Docente.deleteTeacher(DAO, idDocente);
                        if (succed)
                            json.put("status", "OK");
                        else
                            json.put("status", "FAILED");
                        out.println(json);
                        System.out.println(json);
                    }

                } catch (Exception e) {
                    json.put("status", "INVALID_PARAMETERS");
                    System.out.println(json);
                    out.print(json);
                }
            }
        } else {
            //accesso negato
            json.put("status", "AUTHENTICATION_REQUIRED");
            System.out.println(json);
            out.print(json);
        }
    }

}
