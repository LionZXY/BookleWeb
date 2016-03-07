#include <vector>
#include <algorithm>
#include "rice/Class.hpp"
#include "rice/String.hpp"
#include <limits>
#include <ctype.h>

using namespace Rice;

template<typename T>
typename T::size_type levenshtein_distance(const T &src, const T &dst);
bool isEqual(char a, char b);
std::vector<std::string> split(const std::string &s);

void fullMatrix(int **matrix, int **matrixGraf, int x, int y, int maxX, int maxY);

int eq_text(String req, String textS);

int eq_text(String req, String textS) {
    std::string request = req.str();
    std::string text = textS.str();
    std::vector<std::string> arr_req = split(request);
    std::vector<std::string> arr_text = split(text);
    int n = (int) arr_req.size();
    int m = (int) arr_text.size();
    int mini = std::min(n, m);
    const int maxInteger = std::numeric_limits<int>::max();
    int **matrix = new int *[n];
    int **matrixGraf = new int *[n];
    for (int i = 0; i < n; i++) {
        matrix[i] = new int[m];
        matrixGraf[i] = new int[m];
        for (int j = 0; j < m; j++) {
            matrix[i][j] = (int) levenshtein_distance(arr_req[i], arr_text[j]);
            matrixGraf[i][j] = maxInteger;
        }
    }

    //"Сжигание" вершин графа
    matrixGraf[0][0] = matrix[0][0];
    int maxV = 0;
    for (int i = 0; i < mini; i++) {
        maxV = i + 1;
        for (int j = 1; j < maxV; j++) {
            fullMatrix(matrix, matrixGraf, i - j, i, n, m);
            fullMatrix(matrix, matrixGraf, i, i - j, n, m);
        }
        fullMatrix(matrix, matrixGraf, i, i, n, m);
    }


    if (n < m) {
        for (int i = 0; i < n; i++)
            for (int j = n - 1; j < m; j++) {
                fullMatrix(matrix, matrixGraf, i, j, n, m);
            }
    } else {
        for (int i = 0; i < m; i++)
            for (int j = m - 1; j < n; j++) {
                fullMatrix(matrix, matrixGraf, j, i, n, m);
            }
    }

    return matrixGraf[n - 1][m - 1];
}

void fullMatrix(int **matrix, int **matrixGraf, int x, int y, int maxX, int maxY) {
    if (x + 1 < maxX) {
        matrixGraf[x + 1][y] = std::min(matrixGraf[x + 1][y], matrixGraf[x][y] + matrix[x + 1][y]);
        if (y + 1 < maxY)
            matrixGraf[x + 1][y + 1] = std::min(matrixGraf[x + 1][y + 1], matrixGraf[x][y] + matrix[x + 1][y + 1]);
    }
    if (y + 1 < maxY)
        matrixGraf[x][y + 1] = std::min(matrixGraf[x][y + 1], matrixGraf[x][y] + matrix[x][y + 1]);
}

inline bool space(char c) {
    return std::isspace(c);
}

inline bool notspace(char c) {
    return !std::isspace(c);
}

//break a sentence into words
std::vector<std::string> split(const std::string &s) {
    typedef std::string::const_iterator iter;
    std::vector<std::string> ret;
    iter i = s.begin();
    while (i != s.end()) {
        i = std::find_if(i, s.end(), notspace); // find the beginning of a word
        iter j = std::find_if(i, s.end(), space); // find the end of the same word
        if (i != s.end()) {
            ret.push_back(std::string(i, j)); //insert the word into vector
            i = j; // repeat 1,2,3 on the rest of the line.
        }
    }
    return ret;
}


//CopyPaste from Wiki
template<typename T>
typename T::size_type levenshtein_distance(const T &src, const T &dst) {
    const typename T::size_type m = src.size();
    const typename T::size_type n = dst.size();
    if (m == 0) {
        return n;
    }
    if (n == 0) {
        return m;
    }

    std::vector<std::vector<typename T::size_type> > matrix(m + 1);

    for (typename T::size_type i = 0; i <= m; ++i) {
        matrix[i].resize(n + 1);
        matrix[i][0] = i;
    }
    for (typename T::size_type i = 0; i <= n; ++i) {
        matrix[0][i] = i;
    }

    typename T::size_type above_cell, left_cell, diagonal_cell, cost;

    for (typename T::size_type i = 1; i <= m; ++i) {
        for (typename T::size_type j = 1; j <= n; ++j) {
            cost = isEqual(src[i - 1], dst[j - 1]) ? 0 : 1;
            above_cell = matrix[i - 1][j];
            left_cell = matrix[i][j - 1];
            diagonal_cell = matrix[i - 1][j - 1];
            matrix[i][j] = std::min(std::min(above_cell + 1, left_cell + 1), diagonal_cell + cost);
        }
    }

    return matrix[m][n];
}

bool isEqual(char a, char b){
return tolower(a) == tolower(b) || tolower(a + ((int)'а' - (int)'a')) == tolower(b) || tolower(a) == tolower(b + ((int)'а' - (int)'a'));
}

extern "C"

void Init_search()
{
    Class rb_c = define_class("Search")
            .define_method("eq_text", &eq_text);
}
