s=$(clingo Experiments/0028-clique_path_4_4-36-1.asp clique.lp | tac | awk '!flag; /clique/{flag = 1};'| tac | head -1| sed -e 's/)/)./g')
echo "$s"
python append_clique.py "$s"