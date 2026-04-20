#
# Run with:
#   pip install pytest requests  # install dependencies.
#   pytest -v
#
import requests
import pytest

TESTCASES = [
    {
        "url": "https://lode-ndc-dev.apps.cloudpub.testedev.istat.it/extract?url=https://w3id.org/italia/onto/CPV",
        "expected": "Annotation Properties",
        "repo": "github.com/teamdigitale/dati-semantic-lode",
    },
    {
        "url": "https://ndc-dev.apps.cloudpub.testedev.istat.it",
        "expected": "Content-Security-Policy",
        "repo": "github.com/teamdigitale/dati-semantic-frontend",
    },
    {
        "url": "https://lod-ndc-dev.apps.cloudpub.testedev.istat.it/onto/CPV",
        "expected": "Ontologia delle persone",
        "repo": "github.com/teamdigitale/dati-semantic-lodview",
    },
    {
        "url": "https://ndc-dev.apps.cloudpub.testedev.istat.it/api/vocabularies/",
        "expected": "totalCount",
        "repo": "github.com/teamdigitale/dati-semantic-backend",
    },
    {
      "url": "https://virtuoso-dev-external-service-ndc-dev.apps.cloudpub.testedev.istat.it/sparql?default-graph-uri=&query=select+distinct+%3Fprop+%3Fvalue+where+%7B+%3Chttps%3A%2F%2Fw3id.org%2Fitalia%2Fonto%2FAtlasOfPaths%3E+%3Fprop+%3Fvalue%7D+LIMIT+2&format=text%2Fturtle&timeout=0&signal_void=on",
      "expected": "owl:NamedIndividual",
      "repo": "External Service Virtuoso"
    }
]


@pytest.mark.parametrize("testcase", TESTCASES)
def test_ndc(testcase):
    url = testcase["url"]
    expected = testcase["expected"]
    repo = testcase["repo"]
    print("Testing %s" % url)
    r = requests.get(url)
    assert r.status_code == 200
    assert expected in r.text, 'Expected "%s" in response from %s' % (expected, repo)