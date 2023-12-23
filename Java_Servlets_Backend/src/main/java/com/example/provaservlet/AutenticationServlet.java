package com.example.provaservlet;

import DAO.DAO;

import java.io.*;
import java.util.Objects;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import javax.servlet.annotation.*;

import DAO.*;
import com.google.gson.Gson;
import org.json.simple.JSONObject;

@WebServlet(name = "autentication", value = "/autentication")
public class AutenticationServlet extends HttpServlet {
    private String message;
    private DAO DAO = null;

    public void init(ServletConfig config) {
        ServletContext ctx = config.getServletContext();
        DAO = (DAO) ctx.getAttribute("DAO");
    }
    //logout
    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
      /*  response.setHeader("Access-Control-Allow-Origin", "*");
        response.addHeader("Access-Control-Allow-Credentials", "true");

        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession(false);
        if(s!=null) {
            s.invalidate();
            System.out.println("** LOGOUT - INVALIDATE SESSION **");
            out.print("OK");
        }else{
            out.print("ERROR");
            System.out.println("LOGOUT ERROR");
        }*/
    }

    //login
    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setHeader("Access-Control-Allow-Origin", "*");
        response.setHeader("Access-Control-Allow-Credentials", "true");

        PrintWriter out = response.getWriter();
        HttpSession s = request.getSession();

        System.out.println("--------------------------------------------- auth");
        if(s.isNew())System.out.println("Sessione nuova");
        else System.out.println("Session id: "+s.getId());
        System.out.println("attributo username della sessione: "+s.getAttribute("username") );


        String action = request.getParameter("action");
        if(Objects.equals(action, "logout")){
            System.out.println("-------------------------------------richiesta logout");
            if(s!=null) {
                if(s.isNew())System.out.println("Sessione nuova");
                else System.out.println("Sessione recuperata");
                System.out.println("** LOGOUT - INVALIDATE SESSION **");
                JSONObject json = new JSONObject();
                json.put("status", "OK");
                out.print(json);
                s.invalidate();
            }else{
                JSONObject json = new JSONObject();
                json.put("status", "ERROR");
                out.print(json);
                System.out.println("LOGOUT ERROR");
            }
        }
        else{
            System.out.println("-------------------------------------richiesta login");
            String user = request.getParameter("username");
            String pwd = request.getParameter("password");
            String jsessionID = s.getId();
            System.out.println("**** "+user+" - "+pwd+" - JSESSIONID: "+jsessionID+"  ****");

            if(s.isNew())System.out.println("Sessione nuova");

            if (s.getAttribute("utente") == null) {//Client non si è ancora loggato.(mai impostato attributi di sessione)
                if (user != null && pwd != null) {//login
                    Utente newUser = Utente.searchUser(DAO, user, pwd);
                    if (newUser != null) {//login ok
                        loginOk(request,response,newUser);
                    } else {//login failed
                        sendToClient(response,null,null,"INCORRECT_USERNAME_OR_PASSWORD");
                    }
                } else {//user o pwd a null
                    sendToClient(response,null,null,"INVALID_USERNAME_PASSWORD");
                }
            } else{ //sessione già esistente
                //client già loggato ma ha eseguito il refresh
                // forniamo id sessione e dati utente
                    sendToClient(response,s.getId(),(Utente)s.getAttribute("utente"),null);
                }
        }

    }
    private void loginOk(HttpServletRequest request, HttpServletResponse response, Utente u) throws IOException{
        response.setContentType("application/json");
        HttpSession s = request.getSession();
        s.setAttribute("utente", u);
        s.setAttribute("username", u.getUsername());
        System.out.println("set attribute username: " +s.getAttribute("username"));

        // Imposta il timeout della sessione a 30 minuti
        s.setMaxInactiveInterval(30 * 60);

        /* imposta il cookie dell'ID di sessione
        String jsessionID = s.getId();
        Cookie sessionCookie = new Cookie("JSESSIONID", jsessionID);
        sessionCookie.setPath("/");
        sessionCookie.setDomain("localhost");
        sessionCookie.setHttpOnly(true);
        response.addCookie(sessionCookie);*/

        sendToClient(response,s.getId(),u,null);
    }


    private void sendToClient(HttpServletResponse response, String sessionId, Utente u, String errorMsg) throws IOException{
        JSONObject json = new JSONObject();
        try {
            if(u!=null){
                json.put("sessionId", sessionId);
                //json.put("email", new Gson().toJson(u));
                json.put("username", u.getUsername());
                json.put("ruolo", u.getRuolo());
            }
            json.put("errorMsg", errorMsg);
        }catch (Exception e){e.printStackTrace();}

        PrintWriter out = response.getWriter();
        System.out.println(json);
        out.print(json);
    }
}
