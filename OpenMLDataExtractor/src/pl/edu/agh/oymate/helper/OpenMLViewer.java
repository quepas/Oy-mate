package pl.edu.agh.oymate.helper;

import org.openml.apiconnector.xml.*;

import java.util.Arrays;

/**
 * Created by Quepas on 2014-11-27.
 */
public class OpenMLViewer {

    public static void display(DataQualityList dataQualityList) {
        String [] qualities = dataQualityList.getQualities();
        for (int idx = 0; idx < qualities.length; ++idx) {
            ConsoleIO.puts("\t" + (idx+1) + ". " + qualities[idx]);
        }
    }

    public static void display(Authenticate authenticate) {
        ConsoleIO.puts("\tSession hash: " + authenticate.getSessionHash());
        ConsoleIO.puts("\tTimezone: " + authenticate.getTimezone());
        ConsoleIO.puts("\tValid until: " + authenticate.getValidUntil());
    }

    public static void display(DataSetDescription dataSetDescription) {
        ConsoleIO.puts("\tCollection date: " + dataSetDescription.getCollection_date());
        ConsoleIO.puts("\tName: " + dataSetDescription.getName());
        ConsoleIO.puts("\tOml: " + dataSetDescription.getOml());
        ConsoleIO.puts("\tDefault target attribute: " + dataSetDescription.getDefault_target_attribute());
        ConsoleIO.puts("\tDescription: " + dataSetDescription.getDescription());
        ConsoleIO.puts("\tFormat: " + dataSetDescription.getFormat());
        ConsoleIO.puts("\tLanguage: " + dataSetDescription.getLanguage());
        ConsoleIO.puts("\tLicense: " + dataSetDescription.getLicence());
        ConsoleIO.puts("\tMD5: " + dataSetDescription.getMd5_checksum());
        ConsoleIO.puts("\tRow id attribute: " + dataSetDescription.getRow_id_attribute());
        ConsoleIO.puts("\tUpload date: " + dataSetDescription.getUpload_date());
        ConsoleIO.puts("\tURL: " + dataSetDescription.getUrl());
        ConsoleIO.puts("\tVersion: " + dataSetDescription.getVersion());
        ConsoleIO.puts("\tVisibility: " + dataSetDescription.getVisibility());
        ConsoleIO.puts("\tContributor: " + Arrays.toString(dataSetDescription.getContributor()));
        ConsoleIO.puts("\tCreator: " + Arrays.toString(dataSetDescription.getCreator()));
        ConsoleIO.puts("\tID: " + dataSetDescription.getId());
        ConsoleIO.puts("\tIgnore attribute: " + Arrays.toString(dataSetDescription.getIgnore_attribute()));
        ConsoleIO.puts("\tTag: " + Arrays.toString(dataSetDescription.getTag()));
    }

    public static void display(DataFeature dataFeature) {
        ConsoleIO.puts("\tOml: " + dataFeature.getOml());
        ConsoleIO.puts("\tError: " + dataFeature.getError());
        ConsoleIO.puts("\ttoString: " + dataFeature.toString());
        ConsoleIO.puts("\tDid: " + dataFeature.getDid());
        ConsoleIO.puts("\tFeatures:");
        DataFeature.Feature[] features = dataFeature.getFeatures();
        for (int idx = 0; idx < features.length; ++idx) {
            ConsoleIO.puts("\t---------- Feature " + (idx+1) + " ----------");
            display(features[idx]);
        }
    }

    public static void display(DataFeature.Feature feature) {
        ConsoleIO.puts("\t\tClass Distribution: " + feature.getClassDistribution());
        ConsoleIO.puts("\t\ttoString: " + feature.toString());
        ConsoleIO.puts("\t\tDataType: " + feature.getDataType());
        ConsoleIO.puts("\t\tName: " + feature.getName());
        ConsoleIO.puts("\t\tIndex: " + feature.getIndex());
        ConsoleIO.puts("\t\tIsTarget: " + feature.getIs_target());
        ConsoleIO.puts("\t\tMax Value: " + feature.getMaximumValue());
        ConsoleIO.puts("\t\tMean Value: " + feature.getMeanValue());
        ConsoleIO.puts("\t\tMin Value: " + feature.getMinimumValue());
        ConsoleIO.puts("\t\tNum. Distinct Values: " + feature.getNumberOfDistinctValues());
        ConsoleIO.puts("\t\tNum. Integer Values: " + feature.getNumberOfIntegerValues());
        ConsoleIO.puts("\t\tNum. Missing Values: " + feature.getNumberOfMissingValues());
        ConsoleIO.puts("\t\tNum. Nominal Values: " + feature.getNumberOfNominalValues());
        ConsoleIO.puts("\t\tNum. Real Values: " + feature.getNumberOfRealValues());
        ConsoleIO.puts("\t\tNum. Unique Values: " + feature.getNumberOfUniqueValues());
        ConsoleIO.puts("\t\tNum of Values: " + feature.getNumberOfValues());
        ConsoleIO.puts("\t\tStandard Deviation: " + feature.getStandardDeviation());
    }

    public static void display(DataQuality dataQuality) {
        ConsoleIO.puts("\tError: " + dataQuality.getError());
        ConsoleIO.puts("\tOml: " + dataQuality.getOml());
        ConsoleIO.puts("\tID: " + dataQuality.getDid());
        ConsoleIO.puts("\tQuality names: " + Arrays.toString(dataQuality.getQualityNames()));
        DataQuality.Quality[] qualities = dataQuality.getQualities();
        for (int idx = 0; idx < qualities.length; ++idx) {
            ConsoleIO.puts("\t---------- Quality " + (idx+1) + " ----------");
            display(qualities[idx]);
        }
    }

    public static void display(DataQuality.Quality quality) {
        ConsoleIO.puts("\t\tName: " + quality.getName());
        ConsoleIO.puts("\t\tValue: " + quality.getValue());
        ConsoleIO.puts("\t\tInterval start: " + quality.getInterval_start());
        ConsoleIO.puts("\t\tInterval end: " + quality.getInterval_end());
    }

}
