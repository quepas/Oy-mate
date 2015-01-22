package pl.edu.agh.oymate.apps;

import org.openml.apiconnector.io.OpenmlConnector;
import org.openml.apiconnector.xml.*;
import pl.edu.agh.oymate.helper.ConsoleIO;
import pl.edu.agh.oymate.helper.OpenMLUtil;
import pl.edu.agh.oymate.helper.OpenMLViewer;

/**
 * Created by Quepas on 2014-11-27.
 */
public class DataExtractor {

    public static void main(String[] args) {
        ConsoleIO.puts("=== OpenML Data Extractor ===");
        OpenmlConnector client = OpenMLUtil.authorizeUserAndConnect();
        ConsoleIO.puts("OpenML inner data! All data qualities!");
        try {
            DataQualityList dataQualityList = client.openmlDataQualityList();
            OpenMLViewer.display(dataQualityList);
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        int data_id = ConsoleIO.inputInt("Enter data id: ");
        ConsoleIO.puts("Donwload data with id " + data_id + "!");
        /*for (int data_id = 1229; data_id <= 1320; ++data_id) {
            try {
                DataSetDescription dataSet = client.openmlDataGet(data_id);
                ConsoleIO.puts(dataSet.getDataset(sessionHash).getAbsolutePath());
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }*/
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
