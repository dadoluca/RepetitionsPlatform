package DAO;

/**
 * Exception throwable by the libraries that implement crud operations.
 * @author Dadone, Benotto
 */
public class DAOException extends RuntimeException{
    public DAOException(String message){
        super(message);
    }
}
