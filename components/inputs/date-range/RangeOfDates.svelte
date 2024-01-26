<script lang="ts">
	import { Calendar as CalendarIcon } from 'radix-icons-svelte';
	import type { DateRange } from 'bits-ui';
	import {
		CalendarDate,
		DateFormatter,
		getLocalTimeZone,
		today,
		startOfMonth,
		endOfMonth,
		type DateValue,
		fromDate
	} from '@internationalized/date';
	import { cn } from '$lib/utils.js';
	import { Button } from '$lib/shadcn/button/index.js';
	import { RangeCalendar } from '$lib/shadcn/range-calendar/index.js';
	import * as Select from '$lib/shadcn/select/index.js';
	import * as Popover from '$lib/shadcn/popover/index.js';

	const dfMedium = new DateFormatter('en-US', {
		dateStyle: 'medium'
	});

	const dfShort = new DateFormatter('en-US', {
		dateStyle: 'short'
	});

	export let selectedDateRange: DateRange | undefined;
	export let start: string | Date | undefined;
	export let end: string | Date | undefined;

	const current_day = today(getLocalTimeZone());


	let calendarStart: DateValue | undefined;
	$: if (start instanceof Date) {
		calendarStart = fromDate(start, 'Etc/UTC');
	} else if (typeof start === 'string') {
		const pieces = start.split('-');
		calendarStart = new CalendarDate(Number(pieces[0]), Number(pieces[1]), Number(pieces[2]));
	} else {
        calendarStart = fromDate(new Date(0), 'Etc/UTC');
    }

	let calendarEnd: DateValue | undefined;
	$: if (end instanceof Date) {
		calendarEnd = fromDate(end, 'Etc/UTC');
	} else if (typeof end === 'string') {
		const pieces = end.split('-');
		calendarEnd = new CalendarDate(Number(pieces[0]), Number(pieces[1]), Number(pieces[2]));
	} else {
        calendarEnd = current_day;
    }

    // symbols so `lastStart !== calendarStart` doesn't get caught by undefineds
    let lastStart: any = Symbol(), lastEnd: any = Symbol();
    $: if (!selectedDateRange || (lastStart !== calendarStart) || (lastEnd !== calendarEnd)) {
        selectedDateRange = {
            start: calendarStart ?? fromDate(new Date(0), 'Etc/UTC'),
            end: calendarEnd ?? current_day
        };
        lastStart = calendarStart;
        lastEnd = calendarEnd;
    }

	type Preset = {
		label: string;
		range: DateRange;
	};

	$: presets = [
		{
			label: 'Last 7 Days',
			range: {
				start: calendarEnd.subtract({ days: 7 }),
				end: calendarEnd
			}
		},
		{
			label: 'Last 12 Months',
			range: {
				start: startOfMonth(calendarEnd.subtract({ months: 12 })),
				end: endOfMonth(calendarEnd.subtract({ months: 1 }))
			}
		}
	] as Preset[];

	let selectedPreset: Preset | undefined = undefined;
	let placeholder;
</script>

<div class="flex">
	<Popover.Root openFocus>
		<Popover.Trigger asChild let:builder>
			<Button
				variant="outline"
				size="sm"
				class={cn(
					'flex justify-start rounded-r-none border-r-0 text-left font-normal',
					!selectedDateRange && 'text-gray-400'
				)}
				builders={[builder]}
			>
				<CalendarIcon class="mr-2 h-4 w-4" />
				<span class="hidden sm:inline">
					{#if selectedDateRange && selectedDateRange.start}
						{#if selectedDateRange.end}
							{dfMedium.format(selectedDateRange.start.toDate(getLocalTimeZone()))} - {dfMedium.format(
								selectedDateRange.end.toDate(getLocalTimeZone())
							)}
						{:else}
							{dfMedium.format(selectedDateRange.start.toDate(getLocalTimeZone()))}
						{/if}
					{:else if placeholder}
						{dfMedium.format(placeholder.toDate(getLocalTimeZone()))}
					{:else}
						Date Range
					{/if}
				</span>
				<span class="sm:hidden">
					{#if selectedDateRange && selectedDateRange.start}
						{#if selectedDateRange.end}
							{dfShort.format(selectedDateRange.start.toDate(getLocalTimeZone()))} - {dfShort.format(
								selectedDateRange.end.toDate(getLocalTimeZone())
							)}
						{:else}
							{dfShort.format(selectedDateRange.start.toDate(getLocalTimeZone()))}
						{/if}
					{:else if placeholder}
						{dfShort.format(placeholder.toDate(getLocalTimeZone()))}
					{:else}
						Date Range
					{/if}
				</span>
			</Button>
		</Popover.Trigger>
		<Popover.Content class="w-auto select-none p-0" align="start">
			<RangeCalendar
				bind:value={selectedDateRange}
				bind:placeholder
				initialFocus
				numberOfMonths={1}
				onValueChange={() => {
					selectedPreset = undefined;
				}}
				minValue={calendarStart}
				maxValue={calendarEnd}
			/>
		</Popover.Content>
	</Popover.Root>

	<Select.Root
		onSelectedChange={(v) => {
			if (!v) return;
			selectedDateRange = presets.filter((presets) => presets.label == v.label)[0].range;
			selectedPreset = v;
		}}
		bind:selected={selectedPreset}
	>
		<Select.Trigger class="h-8 w-40 rounded-l-none px-3 text-xs font-medium" sameWidth>
			{#if selectedPreset}
				{selectedPreset.label}
			{:else}
				<span class="hidden sm:inline"> Select a Range </span>
				<span class="sm:hidden"> Range </span>
			{/if}
		</Select.Trigger>
		<Select.Content>
			{#each presets as preset}
				<Select.Item value={preset.range} label={preset.label} class="text-xs"
					>{preset.label}</Select.Item
				>
			{/each}
		</Select.Content>
	</Select.Root>
</div>
