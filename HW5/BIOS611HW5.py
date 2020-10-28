import numpy as np
import pandas as pd
from sklearn.manifold import TSNE
from plotnine import ggplot, geom_point, aes, ggsave
df = pd.read_csv(r"C:\Users\Peter\Documents\PhD Semester 1\BIOS 611\HW5\charpowersnumerical.csv")

df_tsne = TSNE().fit_transform(df)
np.savetxt(r"C:\Users\Peter\Documents\PhD Semester 1\BIOS 611\HW5\tsne.txt", df_tsne, fmt="%s")

tsneplot = pd.read_csv(r"C:\Users\Peter\Documents\PhD Semester 1\BIOS 611\HW5\tsnealign.csv")

tsneplotted = ggplot(tsneplot, aes('V1', 'V2', color = 'factor(V3)')) + geom_point()
ggsave(tsneplotted, r"C:\Users\Peter\Documents\PhD Semester 1\BIOS 611\HW5\pythontsne.png")
