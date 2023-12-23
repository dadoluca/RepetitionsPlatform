package com.example.provaservlet;

import DAO.DAO;

import java.io.*;
import java.util.ArrayList;
import java.util.Objects;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import DAO.*;
import com.google.gson.Gson;
import org.json.simple.JSONObject;

@WebServlet(name = "courses", value = "/courses")
public class CoursesServlet extends HttpServlet {
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

        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession();
        Gson gson = new Gson();
        JSONObject json = new JSONObject();
        String action = request.getParameter("action");
        System.out.println("Action: " + action);

        System.out.println("--------------------------------------------- courses");
        if(s.isNew())System.out.println("Sessione nuova");
        else System.out.println("Session id: "+s.getId());
        System.out.println("attributo username della sessione: "+s.getAttribute("username") );

        if(Objects.equals(action, "teacher")){
            if (s.getAttribute("username") != null) {
                int idDocente = -1;
                try {
                    System.out.println("--------------------------------------------- read course teacher");
                    //controllo gli input per la insert
                    idDocente = Integer.parseInt(request.getParameter("idDocente"));
                    System.out.println("docente: " + idDocente);
                    if (idDocente == -1) {
                        json.put("status", "INVALID_PARAMETERS");
                        System.out.println(json);
                        out.print(json);
                    } else {
                        ArrayList<Corso> corsi = Corso.readTeacherCourse(DAO,idDocente);
                        json.put("status", "OK");
                        json.put("corsi", new Gson().toJson(corsi));
                        out.println(json);
                        System.out.println(json);
                    }

                } catch (Exception e) {
                    json.put("status", "INVALID_PARAMETERS");
                    System.out.println(json);
                    out.print(json);
                }
            }
        }
        else{

            ArrayList<Corso> corsi = Corso.readAll(DAO);
            String res = gson.toJson(corsi);
            out.println(res);
        }


       // if (s.getAttribute("utente") != null) {

            //Prelevo i dati dal db

        //}else{
            //accesso negato
        //}

    }


    /*esempio di servlet che controlla la JSESSIOID nei cookies della chiamata*/
    /*
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        System.out.println("-------------------------------------- get courses");

        // cors policy -- permette di effettuare chiamate alla servlet da un'altra porta
        response.setHeader("Access-Control-Allow-Origin", "*");
        //response.addHeader("Access-Control-Allow-Origin", "http://localhost:8080");
        response.addHeader("Access-Control-Allow-Credentials", "true");

        response.setContentType("application/json");

        // cerca il cookie dell'ID di sessione
        Cookie[] cookies = request.getCookies();
        String sessionId = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("JSESSIONID")) {
                    sessionId = cookie.getValue();
                    break;
                }
                System.out.println(cookie.getName() + " " + cookie.getValue());
            }
        }
        if(cookies==null) System.out.println("cookies a null");
        else if(sessionId == null) System.out.println("sessionId non trovato tra i cookies ");
        else System.out.println("JSESSIONID: "+sessionId+ " from cookies");

        if (sessionId == null) {
            // il client non ha inviato il cookie dell'ID di sessione, invia un errore al client
            System.out.println("UNAUTHORIZED il client non ha inviato il cookie dell'ID di sessione");
            return;
        }

        HttpSession s = request.getSession(false);

        if (s == null || !s.getId().equals(sessionId)) {
            // il client non è autenticato o la sessione non è valida, invia un errore al client
            System.out.println("UNAUTHORIZED 2");
            return;
        }
        else{
            // il client è autenticato e la sessione è valida, procedi con il resto della logica della servlet...
            System.out.println("AUTHORIZED "+s.getAttribute("username"));
            System.out.println(s.getId() + " == " + sessionId);
        }

    }

     */
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
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
            if(Objects.equals(action, "delete-course-teacher"))
            {
                int idCorso = -1;
                int idDocente = -1;

                try {
                    System.out.println("--------------------------------------------- delete course - teacher");
                    //controllo gli input per la insert
                    idDocente = Integer.parseInt(request.getParameter("idDocente"));
                    idCorso = Integer.parseInt(request.getParameter("idCorso"));
                    System.out.println("docente: " + idDocente);
                    System.out.println("corso: " + idCorso);
                    if (idDocente == -1 && idCorso == -1) {
                        json.put("status", "INVALID_PARAMETERS");
                        System.out.println(json);
                        out.print(json);
                    } else {
                        succed = Corso.deleteCourseTeacher(DAO, idCorso, idDocente);
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
            else if(Objects.equals(action, "insert-course-teacher")){
                int idDocente = -1;
                int idCorso = -1;
                try {
                    System.out.println("--------------------------------------------- insert course-teacher");
                    //controllo gli input per la delete
                    idDocente = Integer.parseInt(request.getParameter("idDocente"));
                    idCorso = Integer.parseInt(request.getParameter("idCorso"));

                    if (idDocente == -1 || idCorso == -1) {
                        json.put("status", "INVALID_PARAMETERS");
                        System.out.println(json);
                        out.print(json);
                    } else {
                        succed = Corso.createCourseTeacher(DAO, idCorso, idDocente);
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
            else if(Objects.equals(action, "insert-course")) {
                String nomeCorso = "";
                try {
                    System.out.println("--------------------------------------------- insert course");
                    //controllo gli input per la delete
                    nomeCorso = request.getParameter("nome");

                    if (nomeCorso == null) {
                        json.put("status", "INVALID_PARAMETERS");
                        System.out.println(json);
                        out.print(json);
                    } else {
                        succed = Corso.createCorso(DAO, nomeCorso);
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
            }else if(Objects.equals(action, "delete-course")) {
                int idCorso = -1;
                try {
                    System.out.println("--------------------------------------------- delete course");
                    //controllo gli input per la delete
                    idCorso = Integer.parseInt(request.getParameter("id"));

                    if (idCorso == -1) {
                        json.put("status", "INVALID_PARAMETERS");
                        System.out.println(json);
                        out.print(json);
                    } else {
                        succed = Corso.deleteCorso(DAO, idCorso);
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
