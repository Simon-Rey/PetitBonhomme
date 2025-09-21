import os.path
from collections import defaultdict

import yaml


if __name__ == "__main__":
    with open(os.path.join('..', 'petitbonhomme', '_data', 'day_logs.yml'), 'r',
              encoding='utf-8') as file:
        all_logs = yaml.safe_load(file)

        log_per_year = defaultdict(list)
        for log in all_logs:
            year = log["date"].split("-")[0]
            log_per_year[year].append(log)

        for year, logs in log_per_year.items():
            with open(os.path.join('..', 'petitbonhomme', '_data', f'day_logs_{year}.yml'), 'w',
                      encoding='utf-8') as out_file:
                yaml.dump(logs, out_file, sort_keys=False, encoding='utf-8', allow_unicode=True)

