package pl.edu.agh.oymate;

import org.openml.apiconnector.io.ApiException;
import org.openml.apiconnector.io.OpenmlConnector;
import org.openml.apiconnector.xml.*;
import pl.edu.agh.oymate.helper.ConsoleIO;
import pl.edu.agh.oymate.helper.OpenMLViewer;

/**
 * Created by Quepas on 2014-11-27.
 */
public class DataExtractor {

    public static void main(String[] args) {
        ConsoleIO.puts("=== OpenML Data Extractor ===");
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

        ConsoleIO.puts("OpenML inner data! All data qualities!");
        try {
            DataQualityList dataQualityList = client.openmlDataQualityList();
            OpenMLViewer.display(dataQualityList);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        int data_id = ConsoleIO.inputInt("Enter data id: ");
        ConsoleIO.puts("Inspect data with id " + data_id + "!");
        try {
            ConsoleIO.puts("---------- DataSetDescription ----------");
            DataSetDescription dataSet = client.openmlDataGet(data_id);
            OpenMLViewer.display(dataSet);
            ConsoleIO.puts("---------- DataFeature ----------");
            DataFeature dataFeature = client.openmlDataFeatures(data_id);
            OpenMLViewer.display(dataFeature);
            ConsoleIO.puts("---------- DataQuality ----------");
            DataQuality dataQuality = client.openmlDataQuality(data_id);
            OpenMLViewer.display(dataQuality);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
