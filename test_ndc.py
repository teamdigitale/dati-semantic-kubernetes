import requests
import pytest

TESTCASES = [
    {
        "url": "https://lode-ndc-dev.apps.cloudpub.testedev.istat.it/lode/extract?url=https://w3id.org/italia/onto/CPV",
        "expected": "Annotation Properties",
        "repo": "github.com/teamdigitale/LODE",
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
