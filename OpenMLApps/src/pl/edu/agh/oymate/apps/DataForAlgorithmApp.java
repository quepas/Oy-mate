package pl.edu.agh.oymate.apps;

import org.json.JSONArray;
import org.json.JSONObject;
import org.openml.apiconnector.io.OpenmlConnector;
import org.openml.apiconnector.xml.Implementation;
import org.openml.apiconnector.xml.Task;
import pl.edu.agh.oymate.helper.ConsoleIO;
import pl.edu.agh.oymate.helper.OpenMLUtil;
import pl.edu.agh.oymate.helper.OpenMLViewer;
import pl.edu.agh.oymate.pojo.ImplementationSimple;
import pl.edu.agh.oymate.pojo.RunEvaluation;
import pl.edu.agh.oymate.query.SimpleQuery;

import java.util.List;

/**
 * Created by Quepas on 2015-01-21.
 */
public class DataForAlgorithmApp {

    public static void main(String[] args) {
        ConsoleIO.puts("------------ DataForAlgorithmApp ------------");
        OpenmlConnector client = OpenMLUtil.authorizeUserAndConnect();

        try {
            String searchPhrase = "J48";
            List<ImplementationSimple> implementations = SimpleQuery.selectImplementationsContainingName(client, searchPhrase);
            for (ImplementationSimple impl : implementations) {
                ConsoleIO.puts(impl.id + ": " + impl.name);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        int runId = 1;
        try {
            ConsoleIO.puts("Getting " + runId + " run evaluation.");
            List<RunEvaluation> runEvaluations = SimpleQuery.selectRunEvaluation(client, runId);

            for (RunEvaluation run : runEvaluations) {
                ConsoleIO.puts(run.function + ", " + run.value);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
