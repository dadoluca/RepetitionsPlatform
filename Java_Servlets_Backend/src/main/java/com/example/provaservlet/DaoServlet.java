package com.example.provaservlet;

import DAO.DAO;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

@WebServlet(name = "DaoServlet", value = "/DaoServlet",  loadOnStartup = 1, asyncSupported = true)
public class DaoServlet extends HttpServlet {
    private DAO model = null;
    public void init(ServletConfig conf) throws ServletException {
        //super.init(conf);

        //Configuro il DAO all'avvio e lo inserisco nel ServletContext
        System.out.println("Configurazione del DAO dalla INIT");
        ServletContext ctx = conf.getServletContext();
        String url = ctx.getInitParameter("DB-URL");
        String user = ctx.getInitParameter("user");
        String pwd = ctx.getInitParameter("pwd");
        model = new DAO(url,user,pwd);
        //inseriamo il DAO creato nel ServletContext
        ctx.setAttribute("DAO", model);
    }
}
