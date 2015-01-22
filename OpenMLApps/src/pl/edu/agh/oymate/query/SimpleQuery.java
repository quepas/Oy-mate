package pl.edu.agh.oymate.query;

import org.json.JSONArray;
import org.json.JSONObject;
import org.openml.apiconnector.io.OpenmlConnector;
import pl.edu.agh.oymate.helper.ConsoleIO;
import pl.edu.agh.oymate.pojo.ImplementationSimple;
import pl.edu.agh.oymate.pojo.RunEvaluation;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Quepas on 2015-01-22.
 */
public class SimpleQuery {

    private static String SELECT_IMPL_CONTAINING_NAME = "SELECT id, fullName FROM implementation WHERE fullName LIKE '%%%s%%'";
    private static String SELECT_RUN_EVALUATION_BY_ID = "SELECT * FROM evaluation WHERE source=%d";

    public static List<ImplementationSimple> selectImplementationsContainingName(OpenmlConnector client, String searchPhrase) throws Exception {
        List<ImplementationSimple> result = new ArrayList<>();
        JSONObject json = client.openmlFreeQuery(String.format(SELECT_IMPL_CONTAINING_NAME, searchPhrase));
        JSONArray data = json.getJSONArray("data");
        for (int i = 0; i < data.length(); ++i) {
            ImplementationSimple implSimple = new ImplementationSimple();
            implSimple.id = Integer.valueOf(data.getJSONArray(i).getString(0));
            implSimple.name = data.getJSONArray(i).getString(1);
            result.add(implSimple);
        }
        return result;
    }

    public static List<RunEvaluation> selectRunEvaluation(OpenmlConnector client, int runId) throws Exception {
        List<RunEvaluation> result = new ArrayList<>();
        JSONObject json = client.openmlFreeQuery(String.format(SELECT_RUN_EVALUATION_BY_ID, runId));
        JSONArray data = json.getJSONArray("data");
        for (int i = 0; i < data.length(); ++i) {
            JSONArray entry = data.getJSONArray(i);
            RunEvaluation runEvaluation = new RunEvaluation();
            runEvaluation.function = entry.getString(3);
            String value = entry.getString(4);
            if (!value.isEmpty()) runEvaluation.value = Double.valueOf(value);
            String stddev = entry.getString(5);
            if (!stddev.isEmpty()) runEvaluation.stddev = Double.valueOf(stddev);
            runEvaluation.array_data = entry.getString(6);
            result.add(runEvaluation);
        }
        ConsoleIO.puts(json.toString());
        return result;
    }
}
