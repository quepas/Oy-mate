package pl.edu.agh.oymate.helper;

import org.openml.apiconnector.io.ApiException;
import org.openml.apiconnector.io.OpenmlConnector;

/**
 * Created by Quepas on 2015-01-21.
 */
public class OpenMLUtil {

    public static OpenmlConnector authorizeUserAndConnect() {
        ConsoleIO.puts("Login into OpenML!");
        String login = ConsoleIO.input("\tEnter login: ");
        String password = ConsoleIO.inputSecure("\tEnter password: ");

        OpenmlConnector client = new OpenmlConnector(login, password);
        try {
            ConsoleIO.puts("Session info!");
            OpenMLViewer.display(client.openmlAuthenticate());
        } catch (ApiException ex) {
            ConsoleIO.puts("Login error!");
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return client;
    }

}
