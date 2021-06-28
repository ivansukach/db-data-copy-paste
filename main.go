package main

import (
	"context"
	"fmt"
	"github.com/ivansukach/db-data-copy-paste/database"
	"log"
)

const tenantID = "ptech"

func main() {
	configSource, err := readConfig(true)
	if err != nil {
		log.Fatal(fmt.Errorf("failed to read configs: %w", err))
	}

	configReceiver, err := readConfig(false)
	if err != nil {
		log.Fatal(fmt.Errorf("failed to read configs: %w", err))
	}

	tableNames := []string{
		"capability",
		"classifier",
		"classifier_class",
		"classifier_instance",
		"classifier_training_request",
		"classifier_training_request_data",
		"comment",
		"comment_attr_gm",
		"comment_attr_l1",
		"comment_attr_nps",
		"comment_attr_sg",
		"comment_attr_yl",
		"entity",
		"evaluation_event",
		"evaluation_score",
		"flag_inferred",
		"logs_contacted",
		"logs_processed",
		"nps_client",
		"nps_page_sg",
		"nps_response",
		"nps_score",
		"process_result",
		"provider",
		"role_capability",
		"training_example",
		"user",
		"user_role",
		"visitor_history",
		"watchlist",
		"watchlist_activity",
		"watchlist_entity",
		"watchlist_offer",
		"watchlist_user",
	}

	dbSource, err := database.New(context.Background(), &configSource)
	if err != nil {
		log.Fatal(fmt.Errorf("failed to create DB: %w", err))
	}

	dbReceiver, err := database.New(context.Background(), &configReceiver)
	if err != nil {
		log.Fatal(fmt.Errorf("failed to create DB: %w", err))
	}

	for _, name := range tableNames {
		rows, err := dbSource.Pool.Query("SELECT * FROM ibm." + name)
		if err != nil {
			log.Fatal(fmt.Errorf("failed to query rows %s script: %w", name, err))
		}
		cols, err := rows.ColumnTypes()
		fmt.Println(cols)
		for rows.Next() {
			fmt.Println(rows.Lastcols)
			values := ""
			for _, v := range rows.Lastcols{
				values += fmt.Sprintf("'%v', ", v)
			}
			values = values[:len(values)-2]
			//values := fmt.Sprintf("%#v", rows.Lastcols)
			//values = values[15:len(values)-1]
			////strings.ReplaceAll(values, "\"", "'")
			//fmt.Println(values)
			//lastcols := reflect.ValueOf(*rows).FieldByName("lastcols")
			//fmt.Println(lastcols.([]driver.Value))
			_, err = dbReceiver.Pool.Exec("INSERT INTO " + tenantID + "." + name + " VALUES(" + values + ")")
			if err != nil {
				log.Fatal(fmt.Errorf("failed to query rows %s script: %w", name, err))
			}
		}

	}

}
