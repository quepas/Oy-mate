package pl.edu.agh.oymate.helper;

import pl.edu.agh.oymate.pojo.ImplementationSetup;
import pl.edu.agh.oymate.pojo.ImplementationSimple;
import pl.edu.agh.oymate.pojo.RunEvaluation;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Quepas on 2015-01-22.
 */
public class Extractor {

    public static Double getRunEvaluationValue(List<RunEvaluation> runEvaluationList, String metricKey) {
        for (RunEvaluation entry : runEvaluationList) {
            if (entry.function.equals(metricKey)) {
                return entry.value;
            }
        }
        return null;
    }

    public static List<Integer> getImplementationSetupIds(List<ImplementationSetup> implementationSetups) {
        List<Integer> result = new ArrayList<>();
        for (ImplementationSetup entry : implementationSetups) {
            result.add(entry.id);
        }
        return result;
    }

}
