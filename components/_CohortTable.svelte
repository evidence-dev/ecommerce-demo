<script>
    import { DataTable, Column } from "@evidence-dev/core-components";
    export let data;
    export let periodTitle="Cohort Period";
    export let sizeFmt="num0";
    export let valueFmt="pct0";

    // columns must be supplied in standardized form as: cohort period, cohort size, then months proceeding from earliest to latest
    let cols = Object.keys(data[0]);
    let periodCols = cols.slice(2);
</script>

<div class="text-black ml-[36vw] sm:ml-[15vw] pl-10 text-[10pt] font-bold pt-0 pb-0 -mb-4 mt-0">{periodTitle}</div>
<DataTable data={data} rows=all>
    <Column id={cols[0]} fmt="mmm yyyy"/>
    <Column id={cols[1]} align=center fmt={sizeFmt}/>
    {#each periodCols as col, i}
        <Column id={col} title={i+""} fmt={valueFmt} contentType=colorscale colorMax=1 colorMin=0 scaleColor=blue/>
    {/each}
</DataTable>
