import pandas as pd
import wordninja as wn
import nltk
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer

lemmatizer = WordNetLemmatizer()

words = set(nltk.corpus.words.words())
stop = stopwords.words('english')

wn.DEFAULT_LANGUAGE_MODEL = wn.LanguageModel('covid_words.txt.gz')

def drop_nonword(word):
    word = " ".join(w for w in nltk.wordpunct_tokenize(word) \
             if w.lower() in words or not w.isalpha())
    return(word)

def cloud_prep(df):
    df = df.astype(str)
    df['Match'] = df['Match'].apply(wn.split)
    df['Match'] = df['Match'].apply(lambda x: [item for item in x if item not in stop])
    df['Match'] = df.explode('Match', ignore_index=True)
    df = df.astype(str)
    df['Match'] = df['Match'].apply(lemmatizer.lemmatize)
    df['Match'] = df['Match'].apply(drop_nonword)
    return df

malcloud = pd.read_csv("./derived_data/malcloud_prep.csv")
safecloud = pd.read_csv("./derived_data/safecloud_prep.csv")

malcloud = cloud_prep(malcloud)
safecloud = cloud_prep(safecloud)

malcloud.to_csv("./derived_data/malcloud.csv")
safecloud.to_csv("./derived_data/safecloud.csv")
