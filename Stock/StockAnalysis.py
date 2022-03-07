#S&P 500 Stock App
import pandas as pd
import streamlit as st
import yfinance as yf
import matplotlib.pyplot as plt
import base64

# FUNCTIONS
# Plot stock Closing values
def plot_stock(symbol):
    st.write(symbol)
    df = pd.DataFrame(data[symbol].Close)
    st.area_chart(df)
    plt.xticks(rotation=90)
    plt.title(symbol, fontweight='bold')
    plt.xlabel('Date', fontweight='bold')
    plt.ylabel('Closing Price', fontweight='bold')
    plt.show()

# Download the data as CSV
# https://discuss.streamlit.io/t/how-to-download-file-in-streamlit/1806
def filedownload(df):
    csv = df.to_csv(index=False)
    b64 = base64.b64encode(csv.encode()).decode()  # strings <-> bytes conversions
    href = f'<a href="data:file/csv;base64,{b64}" download="SP500.csv">Download CSV File</a>'
    return href


#Streamlit formatting
st.sidebar.header("User Input Features")
st.markdown("""
List of **S&P 500** companies and its corresponding **stock closing price** (year-to-date)
* **Data source:** [Wikipedia](https://en.wikipedia.org/wiki/List_of_S%26P_500_companies).
""")


#Read table data from wikipedia source and store in dataframe
url="https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"
stock_html=pd.read_html(url,header=0)
stock_data=stock_html[0]

#Populate the sidebar with a sorted list of all unique Sectors in the stock_data dataframe
sorted_sector=sorted(stock_data['GICS Sector'].unique())
selected_sector=st.sidebar.selectbox('Sector',sorted_sector)


company_stock_data=stock_data[stock_data['GICS Sector']==selected_sector]
sorted_company=sorted(company_stock_data['Symbol'].unique())
selected_company=st.sidebar.multiselect('Symbol (Select 5 Max)',sorted_company,sorted_company[0])

#Create a dataframe to store stock data for all sectors selected by user
df_selected_sector=stock_data[stock_data['GICS Sector']==selected_sector].sort_values('Symbol')
df_selected_sector.drop(columns=['SEC filings','GICS Sector'],inplace=True)

#Display the list of companies in selected sectors
st.header("Companies under Sector - " + selected_sector)
st.write("Listing " + str(len(df_selected_sector)) + "companies")
st.dataframe(df_selected_sector)

if (len(df_selected_sector)>0):
    st.markdown(filedownload(df_selected_sector), unsafe_allow_html=True)

    #Create a list of symbols for each company in the selected sectors 
    symbolsList=list(df_selected_sector.Symbol)


    #Download the stock data from yahoofinance for the top 5 symbols 
    # https://pypi.org/project/yfinance/
    data = yf.download(
    tickers = list(df_selected_sector.Symbol),
    period = "ytd",
    interval = "1d",
    group_by = 'ticker',
    auto_adjust = True,
    prepost = True,
    threads = True,
    proxy = None)

    if (len(selected_company)<=5):
        header='Stock Closing Price'
    else:
        header='Stock Closing Price - Displaying 5'
    st.header(header)

    for i in selected_company[0:5]: 
        plot_stock(i)

else:
    st.error("Select a sector")