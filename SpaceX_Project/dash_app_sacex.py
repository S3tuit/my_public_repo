import pandas as pd
import dash
from dash import Dash, dcc, html, Input, Output, callback
import plotly.express as px

# Read the airline data into pandas dataframe
spacex_df = pd.read_csv("https://cf-courses-data.s3.us.cloud-object-storage.appdomain.cloud/IBM-DS0321EN-SkillsNetwork/datasets/spacex_launch_dash.csv")
max_payload = spacex_df['Payload Mass (kg)'].max()
min_payload = spacex_df['Payload Mass (kg)'].min()

dropd_1_list = list(spacex_df['Launch Site'].unique())
dropd_1_list.append('All Sites')

# Create a dash application
app = dash.Dash(__name__)

# Create an app layout
app.layout = html.Div(children=[html.H1('SpaceX Launch Records Dashboard',
                                        style={'textAlign': 'center', 'color': '#503D36',
                                               'font-size': 40}),
                                # TASK 1: Add a dropdown list to enable Launch Site selection
                                # The default select value is for ALL sites
                                dcc.Dropdown(dropd_1_list, 'All Sites',id='site-dropdown'),
                                html.Br(),

                                # TASK 2: Add a pie chart to show the total successful launches count for all sites
                                # If a specific launch site was selected, show the Success vs. Failed counts for the site
                                html.Div(dcc.Graph(id='success-pie-chart')),
                                html.Br(),

                                html.P("Payload range (Kg):"),
                                # TASK 3: Add a slider to select payload range
                                dcc.RangeSlider(min_payload, max_payload, (max_payload-min_payload)/10,
                                                value= [3000, 7000],id='payload-slider'),

                                # TASK 4: Add a scatter chart to show the correlation between payload and launch success
                                html.Div(dcc.Graph(id='success-payload-scatter-chart')),
                                ])

# TASK 2:
# Add a callback function for `site-dropdown` as input, `success-pie-chart` as output

# TASK 4:
# Add a callback function for `site-dropdown` and `payload-slider` as inputs, `success-payload-scatter-chart` as output
@app.callback(
    Output('success-pie-chart', 'figure'),
    Output('success-payload-scatter-chart', 'figure'),
    Input('site-dropdown', 'value'),
    Input('payload-slider', 'value')
)
def update_output(dropd_1_value, payl_slider_value):

    if dropd_1_value == 'All Sites':
        pie_chart = px.pie(spacex_df, values='class', names='Launch Site', title='Total Success Launches by Sites')
    else:
        mask = spacex_df['Launch Site'] == dropd_1_value
        pie_chart = px.pie(spacex_df[mask], names='class', title=f'Success Rate in Site: {dropd_1_value}')

    mask2 = (spacex_df['Payload Mass (kg)'] > payl_slider_value[0]) & (spacex_df['Payload Mass (kg)'] < payl_slider_value[1])
    scatter_chart = px.scatter(spacex_df[mask2], x='Payload Mass (kg)', y='class', color='Booster Version Category')

    return pie_chart, scatter_chart

# Run the app
if __name__ == '__main__':
    app.run_server(debug=True)