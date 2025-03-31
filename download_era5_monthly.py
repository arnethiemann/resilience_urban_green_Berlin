import cdsapi

dataset = "reanalysis-era5-single-levels-monthly-means"
request = {
    "product_type": ["monthly_averaged_reanalysis"],
    "variable": [
        "2m_temperature",
        "mean_sea_level_pressure",
        "total_precipitation",
        "land_sea_mask",
        "soil_temperature_level_1",
        "soil_temperature_level_2",
        "soil_temperature_level_3",
        "soil_temperature_level_4",
        "soil_type",
        "volumetric_soil_water_layer_1",
        "volumetric_soil_water_layer_2",
        "volumetric_soil_water_layer_3",
        "volumetric_soil_water_layer_4",
        "precipitation_type",
        "evaporation",
        "potential_evaporation",
        "runoff",
        "sub_surface_runoff",
        "surface_runoff",
        "total_cloud_cover",
        "high_cloud_cover",
        "low_cloud_cover",
        "medium_cloud_cover"
    ],
    "year": [
        "2011", "2012", "2013",
        "2014", "2015", "2016",
        "2017", "2018", "2019",
        "2020", "2021", "2022",
        "2023", "2024"
    ],
    "month": [
        "01", "02", "03",
        "04", "05", "06",
        "07", "08", "09",
        "10", "11", "12"
    ],
    "time": ["00:00"],
    "data_format": "netcdf",
    "download_format": "unarchived",
    "area": [60, -25, 30, 45]
}

client = cdsapi.Client()
client.retrieve(dataset, request).download()
