package pl.edu.agh.oymate.query;

import org.json.JSONArray;
import org.json.JSONObject;
import org.openml.apiconnector.io.OpenmlConnector;
import pl.edu.agh.oymate.helper.Extractor;
import pl.edu.agh.oymate.pojo.*;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Quepas on 2015-01-22.
 */
public class SimpleQuery {

    private static String SELECT_IMPL_CONTAINING_NAME = "SELECT id, fullName FROM implementation WHERE fullName LIKE '%%%s%%'";
    private static String SELECT_RUN_EVALUATION_BY_ID = "SELECT * FROM evaluation WHERE source=%d";
    private static String SELECT_IMPL_SETUPS = "SELECT * FROM algorithm_setup WHERE implementation_id = %d";
    private static String SELECT_DATASET_ID_FROM_TASK = "SELECT value FROM task_inputs WHERE task_id = %d AND input = 'source_data'";
    private static String SELECT_DATASET_INFO = "SELECT * FROM dataset WHERE did = %d";
    private static String SELECT_RUNS_ID = "SELECT rid, task_id, setup FROM run WHERE setup in %s";

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
        return result;
    }

    public static List<ImplementationSetup> selectImplementationSetups(OpenmlConnector client, int implementation_id) throws Exception {
        List<ImplementationSetup> resutl = new ArrayList<>();
        JSONObject json = client.openmlFreeQuery(String.format(SELECT_IMPL_SETUPS, implementation_id));
        JSONArray data = json.getJSONArray("data");
        for (int i = 0; i < data.length(); ++i) {
            JSONArray entry = data.getJSONArray(i);
            ImplementationSetup implementationSetup = new ImplementationSetup();
            implementationSetup.id = Integer.valueOf(entry.getString(0));
            implementationSetup.setup = entry.getString(7);
            resutl.add(implementationSetup);
        }
        return resutl;
    }

    public static Integer selectDatasetIdFromTask(OpenmlConnector client, int task_id) throws Exception {
        JSONObject json = client.openmlFreeQuery(String.format(SELECT_DATASET_ID_FROM_TASK, task_id));
        JSONArray data = json.getJSONArray("data");
        return Integer.valueOf(data.getJSONArray(0).getString(0));
    }

    public static Dataset selectDatasetInfo(OpenmlConnector client, int task_id) throws Exception {
        int dataset_id = selectDatasetIdFromTask(client, task_id);
        JSONObject json = client.openmlFreeQuery(String.format(SELECT_DATASET_INFO, dataset_id));
        JSONArray data = json.getJSONArray("data").getJSONArray(0);
        Dataset dataset = new Dataset();
        dataset.id = Integer.valueOf(data.getString(0));
        dataset.name = data.getString(3);
        dataset.version = Integer.valueOf(data.getString(4));
        dataset.version_label = data.getString(5);
        return dataset;
    }

    public static List<Run> selectAllRunsFromSetups(OpenmlConnector client, List<ImplementationSetup> setups) throws Exception {
        List<Run> result = new ArrayList<>();
        String setupsIds = asSQLList(Extractor.getImplementationSetupIds(setups));
        JSONObject json = client.openmlFreeQuery(String.format(SELECT_RUNS_ID, setupsIds));
        JSONArray data = json.getJSONArray("data");
        for (int i = 0; i < data.length(); ++i) {
            JSONArray entry = data.getJSONArray(i);
            Run run = new Run();
            run.id = Integer.valueOf(entry.getString(0));
            run.task_id = Integer.valueOf(entry.getString(1));
            run.setup_id = Integer.valueOf(entry.getString(2));
            result.add(run);
        }
        return result;
    }

    private static <T> String asSQLList(List<T> list) {
        return list.toString().replace("[", "(").replace("]", ")");
    }
}
