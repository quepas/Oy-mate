package pl.edu.agh.oymate.apps;

import org.openml.apiconnector.io.OpenmlConnector;
import org.openml.apiconnector.xml.RunEvaluate;
import pl.edu.agh.oymate.helper.ConsoleIO;
import pl.edu.agh.oymate.helper.Extractor;
import pl.edu.agh.oymate.helper.OpenMLUtil;
import pl.edu.agh.oymate.pojo.ImplementationSetup;
import pl.edu.agh.oymate.pojo.ImplementationSimple;
import pl.edu.agh.oymate.pojo.Run;
import pl.edu.agh.oymate.pojo.RunEvaluation;
import pl.edu.agh.oymate.query.SimpleQuery;

import java.util.ArrayList;
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
        int implementation_id = 60;
        try {
            ConsoleIO.puts("Getting setups for implementation with id " + implementation_id + ".");
            List<ImplementationSetup> implementationSetups = new ArrayList<>();//SimpleQuery.selectImplementationSetups(client, implementation_id);
            ImplementationSetup asd = new ImplementationSetup();
            asd.id = 5;
            asd.setup = "XXX";
            implementationSetups.add(asd);
            for (ImplementationSetup entry : implementationSetups) {
                ConsoleIO.puts(entry.id + ": " + entry.setup);
            }
            ConsoleIO.puts("Dataset name: " + SimpleQuery.selectDatasetInfo(client, 1).name);
            List<Run> runs = SimpleQuery.selectAllRunsFromSetups(client, implementationSetups);

            for (Run entry : runs) {
                List<RunEvaluation> runEvaluations = SimpleQuery.selectRunEvaluation(client, entry.id);
                Double value = Extractor.getRunEvaluationValue(runEvaluations, "predictive_accuracy");
                if (value != null && value > 0.95) {
                    ConsoleIO.puts("Run id: " + entry.id + ", task id: " + entry.task_id + ", pred acc: " + value);
                    ConsoleIO.puts("data set id: " + SimpleQuery.selectDatasetIdFromTask(client, entry.task_id));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
