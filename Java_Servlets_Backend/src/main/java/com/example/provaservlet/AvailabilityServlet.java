package com.example.provaservlet;

import DAO.Disponibilita;
import DAO.DAO;
import com.google.gson.Gson;
import org.json.simple.JSONObject;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

@WebServlet(name = "availability", value = "/availability")
public class AvailabilityServlet extends HttpServlet {
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

        System.out.println("--------------------------------------------- availability");
        if(s.isNew())System.out.println("Sessione nuova");
        else System.out.println("Session id: "+s.getId());
        System.out.println("attributo username della sessione: "+s.getAttribute("username") );


        JSONObject json = new JSONObject();

        //if (s.getAttribute("username")!=null) {
            int teacherId = -1;
            try{
                teacherId = Integer.parseInt(request.getParameter("teacherId"));
                //Prelevo i dati dal db
                ArrayList<Disponibilita> disponibilitaDoc = Disponibilita.readTeacherAvailability(DAO,teacherId);
                json.put("availability", new Gson().toJson(disponibilitaDoc));
                json.put("status", "OK");
                System.out.println(json);
                out.println(json);

            } catch (Exception e) {
                json.put("status", "INVALID_TEACHER_ID");
                System.out.println(json);
                out.print(json);
            }
       /* }else{
            //accesso negato
            json.put("status", "AUTHENTICATION_REQUIRED");
            System.out.println(json);
            out.print(json);
        }*/
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.addHeader("Access-Control-Allow-Origin", "*");
    }


}
